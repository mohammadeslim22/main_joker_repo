import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/models/location_images.dart';
import 'package:joker/util/size_config.dart';

class HOMEMAProvider with ChangeNotifier {
  bool dataloaded = false;
  MapBranches branches;
  MapBranch selectedBranch;
  MapBranch inFocusBranch;
  bool horizentalListOn = false;
  double rotation;
  bool specesLoaded = false;
  List<Marker> markers = <Marker>[];
  List<Specialization> specializations = <Specialization>[];
  List<LocationImages> locationPics = <LocationImages>[];

  int selectedSpecialize = 1;

  double lat = config.lat ?? 0.0;
  double long = config.long ?? 0.0;

  GoogleMapController mapController;
  List<SaleData> lastSales = <SaleData>[];
  bool offersHorizontalCardsList = false;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  bool specSelected = false;
  int selectedBranchId;
  bool showSlidingPanel = false;
  bool showSepcializationsPad = true;
  SwiperController swipController = SwiperController();
  void toggleShowSlidingPanel() {
    showSlidingPanel = !showSlidingPanel;
    print("showSlidingPanel $showSlidingPanel");
    notifyListeners();
  }

  void toggleSHowSepcializationsPad() {
    showSepcializationsPad = !showSepcializationsPad;
    print("showSepcializationsPad $showSepcializationsPad");
    notifyListeners();
  }

  void makeshowSlidingPanelTrue() {
    showSlidingPanel = true;
    print("showSlidingPanel $showSlidingPanel");
    notifyListeners();
  }

  void makeshowSlidingPanelFalse() {
    showSlidingPanel = false;

    print("showSlidingPanel $showSlidingPanel");
    notifyListeners();
  }

  void makeShowSepcializationsPadFalse() {
    showSepcializationsPad = false;
    print("showSepcializationsPad $showSepcializationsPad");
    notifyListeners();
  }

  void makeShowSepcializationsPadTrue() {
    showSepcializationsPad = true;
    print("showSepcializationsPad $showSepcializationsPad");
    notifyListeners();
  }

  void getSaleLotLang(int branchId) {
    selectedBranch = branches.mapBranches.firstWhere((MapBranch element) {
      return element.id == branchId;
    });
    print(selectedBranch.latitude);
    print(selectedBranch.longitude);
    lat = selectedBranch.latitude;
    long = selectedBranch.longitude;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 17)));
    notifyListeners();
  }

  Future<void> getBranchesData(int specId) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("map", queryParameters: <String, dynamic>{
      'specialization': <int>[specId ?? selectedSpecialize],
      'limit': 20
    });
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
      markerId: MarkerId("user"),
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
          // getIt<HOMEMAProvider>().errorController = getIt<HOMEMAProvider>()
          //     .scaffoldkey
          //     .currentState
          //     .showBottomSheet<dynamic>(
          //       (BuildContext context) => Container(
          //           height: SizeConfig.screenHeight / 2,
          //           // width: SizeConfig.screenWidth,
          //           margin: const EdgeInsets.symmetric(
          //               horizontal: 12, vertical: 16),
          //           child: _buildCarousel(context)),
          //     );
        },
        infoWindow: InfoWindow(title: element.merchant.name.toString()));

    markers.add(marker);
  }

  void showOffersHorizontalCards(int selId) {
    if (selectedBranchId == null) {
      offersHorizontalCardsList = true;
      makeShowSepcializationsPadFalse();
      // makeshowSlidingPanelTrue();
    } else {
      if (selId == selectedBranchId) {
        offersHorizontalCardsList = !offersHorizontalCardsList;
        if (!showSlidingPanel) {
          toggleSHowSepcializationsPad();
        } else {}

        // makeShowSepcializationsPadTrue();
        // makeshowSlidingPanelFalse();
        // if (shoOffersButton) {
        //   //
        // } else {
        //   makeshoOffersButtonfalse();
        // }
        // toggleshoOffersButton();
      } else {
        offersHorizontalCardsList = true;
        makeShowSepcializationsPadFalse();
        // makeshowSlidingPanelTrue();
        // makeshowSlidingPanelTrue();
      }
      // if (offersHorizontalCardsList) {
      //   makeshoOffersButtonTrue();
      // }
    }

    notifyListeners();
  }

  void hideOffersHorizontalCards() {
    offersHorizontalCardsList = false;
    notifyListeners();
  }

  Future<void> editMarkersIcons(MapBranch element) async {
    markers.clear();
    // await _addMarker(_scaffoldkey, element, true);
    for (final MapBranch mapBranch in branches.mapBranches) {
      print("${mapBranch.id} ${element.id} ${mapBranch.id == element.id}");
      await _addMarker(mapBranch, mapBranch.id == element.id);
      print(markers);
    }
    // markers.removeWhere(
    //     (Marker m) => m.markerId == MarkerId(element.id.toString()));
    // await _addMarker(_scaffoldkey, element, true);
    // markers.removeWhere(
    //     (Marker m) => m.markerId != MarkerId(element.id.toString()));
    // for (final MapBranch mapBranch in branches.mapBranches) {
    //   await _addMarker(_scaffoldkey, mapBranch, mapBranch.id == element.id);
    // }
    addUserIcon();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> getSpecializationsData() async {
    final dynamic response = await dio.get<dynamic>("specializations");
    specializations.clear();
    specializations = Specializations.fromJson(response.data).data;
    await getLocationPics();
    specesLoaded = true;
    notifyListeners();
  }

  Future<void> getLocationPics() async {
    final dynamic response = await dio.get<dynamic>("images");
    locationPics.clear();
    response.data.forEach((dynamic v) {
      locationPics.add(LocationImages.fromJson(v));
    });

    notifyListeners();
  }

  void setSlelectedSpec(int id) {
    if (id == selectedSpecialize) {
      selectedSpecialize = null;
    } else {
      selectedSpecialize = id;
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
}
