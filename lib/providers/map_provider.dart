import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/ui/view_models/base_model.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/models/location_images.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/util/size_config.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart';

import 'salesProvider.dart';

class HOMEMAProvider extends BaseModel {
  bool dataloaded = false;
  MapBranches branches;
  MapBranch selectedBranch;
  MapBranch inFocusBranch;
  double rotation;
  bool specesLoaded = false;
  List<Marker> markers = <Marker>[];
  List<Specialization> specializations = <Specialization>[];
  List<LocationImages> locationPics = <LocationImages>[];
  PagewiseLoadController<dynamic> pagewiseSalesController;
  int selectedSpecialize = 1;
  Sales sales;
  Sales tempSales;
  double lat = config.lat ?? 0.0;
  double long = config.long ?? 0.0;

  GoogleMapController mapController;
  List<SaleData> lastSales = <SaleData>[];
  bool offersHorizontalCardsList = false;
  bool specSelected = false;
  int selectedBranchId;
  bool showSlidingPanel = false;
  bool showSepcializationsPad = true;
  SwiperController swipController = SwiperController();
  AnimationController controller;
  
  void setinFocusBranch(MapBranch toBeInFocus) {
    inFocusBranch = toBeInFocus;
    notifyListeners();
  }

  void setLatLomg(double newLat, double newLong) {
    lat = newLat;
    long = newLong;
  }

  void setLikeSale(int saleId) {
    try {
      inFocusBranch.lastsales.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isliked = 1;
      notifyListeners();
      // getIt<SalesProvider>().setLikeSale(saleId);
    } catch (err) {
      print("could not find element");
    }
  }

  void setunLikeSale(int saleId) {
    try {
      inFocusBranch.lastsales.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isliked = 0;
      notifyListeners();
      // getIt<SalesProvider>().setunLikeSale(saleId);
    } catch (err) {
      print("orrrrr");
    }
  }

  void setFavSale(int saleId) {
    try {
      inFocusBranch.lastsales.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isfavorite = 1;
      notifyListeners();
      // getIt<SalesProvider>().setFavSale(saleId);
    } catch (err) {
      print("could not find element $err");
    }
  }

  void setunFavSale(int saleId) {
    try {
      inFocusBranch.lastsales.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isfavorite = 0;
      notifyListeners();
      // getIt<SalesProvider>().setunFavSale(saleId);
    } catch (err) {
      print("orrrrr");
    }
  }

  void toggleShowSlidingPanel() {
    showSlidingPanel = !showSlidingPanel;
    notifyListeners();
  }

  void toggleSHowSepcializationsPad() {
    showSepcializationsPad = !showSepcializationsPad;
    notifyListeners();
  }

  void makeshowSlidingPanelTrue() {
    showSlidingPanel = true;
    notifyListeners();
  }

  void makeshowSlidingPanelFalse() {
    showSlidingPanel = false;

    notifyListeners();
  }

  void makeShowSepcializationsPadFalse() {
    showSepcializationsPad = false;
    notifyListeners();
  }

  void makeShowSepcializationsPadTrue() {
    showSepcializationsPad = true;
    notifyListeners();
  }

  void getSaleLotLang(int branchId) {
    selectedBranch = branches.mapBranches.firstWhere((MapBranch element) {
      return element.id == branchId;
    });
    lat = selectedBranch.latitude;
    long = selectedBranch.longitude;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 17)));
    notifyListeners();
  }

  Future<void> getBranchesData(int specId) async {
    Response<dynamic> response;
    if (getIt<Auth>().isAuthintecated) {
      response =
          await dio.get<dynamic>("map2", queryParameters: <String, dynamic>{
        'specialization': jsonEncode(<int>[specId ?? selectedSpecialize]),
        'limit': 20
      });
    } else {
      response =
          await dio.get<dynamic>("map", queryParameters: <String, dynamic>{
        'specialization': jsonEncode(<int>[specId ?? selectedSpecialize]),
        'limit': 20
      });
    }

    branches = MapBranches.fromJson(response.data);
    markers.clear();
    addUserIcon();
    for (final MapBranch mapBranch in branches.mapBranches) {
      await _addMarker(mapBranch,
          mapBranch.id == (inFocusBranch != null ? inFocusBranch.id : 99999));
    }

    dataloaded = true;

    notifyListeners();
  }

  void setRotation(double r) {
    rotation = r;
    notifyListeners();
  }

  Future<void> addUserIcon() async {
    final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/location_icon.png',
        (SizeConfig.blockSizeHorizontal * 42).toInt());
    markers.add(Marker(
      markerId: const MarkerId("user"),
      position: LatLng(config.lat, config.long),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
  }

  Future<void> _addMarker(MapBranch element, bool focus) async {
    Uint8List markerIcon;
    if (focus) {
      if (element.spec == "restaurant") {
        markerIcon = await getBytesFromAsset(
            'assets/images/ic_quick_link_map_restaurants.png',
            (SizeConfig.blockSizeHorizontal * 46).round());
      } else if (element.spec == "coffeeshop") {
        markerIcon = await getBytesFromAsset('assets/images/coffee_icon.png',
            (SizeConfig.blockSizeHorizontal * 46).round());
      } else {
        markerIcon = await getBytesFromAsset(
            'assets/images/locationMarkerblue.png',
            (SizeConfig.blockSizeHorizontal * 46).round());
      }
    } else {
      if (element.spec == "restaurant") {
        markerIcon = await getBytesFromAsset('assets/images/rest_icon.png',
            (SizeConfig.blockSizeHorizontal * 38).toInt());
      } else if (element.spec == "coffeeshop") {
        markerIcon = await getBytesFromAsset('assets/images/coffee_icon.png',
            (SizeConfig.blockSizeHorizontal * 38).round());
      } else {
        markerIcon = await getBytesFromAsset(
            'assets/images/locationMarkerblue.png',
            (SizeConfig.blockSizeHorizontal * 40).round());
      }
    }

    final Marker marker = Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () async {
          await onClickMarker(element);
        },
        infoWindow: InfoWindow(title: element.merchant.name.toString()));

    markers.add(marker);
  }

  Future<void> onClickMarker(
    MapBranch element,
  ) async {
    inFocusBranch = element;
    editMarkersIcons(element);
    await mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(element.latitude, element.longitude),
      zoom: 17,
    )));
    lastSales = element.lastsales;
    showOffersHorizontalCards(element.id);
    selectedBranchId = element.id;
    swipController.move(0);
  }

  Future<void> onClickCloseMarker() async {
    showOffersHorizontalCards(inFocusBranch.id);
    swipController.move(0);
  }

  void showOffersHorizontalCards(int selId) {
    if (selectedBranchId == null) {
      offersHorizontalCardsList = true;
      controller.forward();

      makeShowSepcializationsPadFalse();
    } else {
      if (selId == selectedBranchId) {
        offersHorizontalCardsList = !offersHorizontalCardsList;
        if (offersHorizontalCardsList) {
          controller.forward();
        } else {
          controller.reverse();
        }
        if (!showSlidingPanel) {
          toggleSHowSepcializationsPad();
        } else {}
      } else {
        offersHorizontalCardsList = true;
        controller.forward();
        makeShowSepcializationsPadFalse();
      }
    }

    notifyListeners();
  }

  void hideOffersHorizontalCards() {
    offersHorizontalCardsList = false;
    if (controller != null) {
      controller.reverse();
    }

    notifyListeners();
  }

  Future<void> editMarkersIcons(MapBranch element) async {
    markers.clear();
    for (final MapBranch mapBranch in branches.mapBranches) {
      await _addMarker(mapBranch, mapBranch.id == element.id);
    }
    addUserIcon();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui
        .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> getSpecializationsData() async {
    final dynamic response = await dio.get<dynamic>("specializations");
    specializations.clear();
    specializations = Specializations.fromJson(response.data).data;
    specesLoaded = true;
    notifyListeners();
  }

  void setSlelectedSpec(int id) {
    if (id == selectedSpecialize) {
    } else {
      selectedSpecialize = id;
      getBranchesData(selectedSpecialize);
    }

    notifyListeners();
  }

  String getSpecializationName() {
    if (specializations.isEmpty) {
      return "";
    }
    return specializations.firstWhere((Specialization element) {
      return element.id == (selectedSpecialize ?? 1);
    }).name;
  }

  Future<List<SaleData>> getSalesDataFilterdAuthenticated(
      int pageIndex, FilterData filterData) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(filterData.startingdate);
    final String endDate = formatter.format(filterData.endingdate);
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'merchant_name': filterData.merchantNameOrPartOfit.isEmpty
          ? ""
          : filterData.merchantNameOrPartOfit,
      'name': filterData.saleNameOrPartOfit.isNotEmpty
          ? filterData.saleNameOrPartOfit
          : "",
      'from_date': startDate,
      'to_date': endDate,
      'from_price': filterData.fromPrice,
      'to_price': filterData.toPrice,
      'specialization': jsonEncode(filterData.specifications)
    });

    sales = Sales.fromJson(response.data);
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataAuthenticated(int pageIndex) async {
    print("page index $pageIndex");
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization':
          jsonEncode(<int>[getIt<HOMEMAProvider>().selectedSpecialize])
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataFilterd(
      int pageIndex, FilterData filterData) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(filterData.startingdate);
    final String endDate = formatter.format(filterData.endingdate);
    final Response<dynamic> response =
        await dio.get<dynamic>("psales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'merchant_name': filterData.merchantNameOrPartOfit,
      'name': filterData.saleNameOrPartOfit,
      'from_date': startDate,
      'to_date': endDate,
      'rate': filterData.rating,
      'specifications': jsonEncode(filterData.specifications)
    });
    sales = Sales.fromJson(response.data);
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesData(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("psales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization':
          jsonEncode(<int>[getIt<HOMEMAProvider>().selectedSpecialize ?? 1])
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;
    notifyListeners();
    return sales.data;
  }

  Future<List<dynamic>> getSales(int pageIndex) {
    return getIt<Auth>().isAuthintecated
        ? (getIt<SalesProvider>().filterData != null)
            ? getSalesDataFilterdAuthenticated(
                pageIndex, getIt<SalesProvider>().filterData)
            : getSalesDataAuthenticated(pageIndex)
        : (getIt<SalesProvider>().filterData != null)
            ? getSalesDataFilterd(pageIndex, getIt<SalesProvider>().filterData)
            : getSalesData(pageIndex);
  }
}
