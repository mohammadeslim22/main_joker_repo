import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/ui/cards/merchant_card_no_padding.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/models/location_images.dart';
import 'package:joker/util/service_locator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
  

  int selectedSpecialize;

  double lat = config.lat ?? 0.0;
  double long = config.long ?? 0.0;

  GoogleMapController mapController;

  void getSaleLotLang(int branchId) {
    selectedBranch = branches.mapBranches.firstWhere((MapBranch element) {
      return element.id == branchId;
    });
    print(selectedBranch.latitude);
    print(selectedBranch.longitude);
    lat = selectedBranch.latitude;
    long = selectedBranch.longitude;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 13,
    )));
    notifyListeners();
  }

  Future<void> getBranchesData(GlobalKey<ScaffoldState> _scaffoldkey,
      double lat, double long, int specId) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("map", queryParameters: <String, dynamic>{
      'specialization': <int>[selectedSpecialize],
      'limit': 20
    });
    branches = MapBranches.fromJson(response.data);
    markers.clear();

    //TODO(mIsleem): use for instead of forEach
    for (final MapBranch mapBranch in branches.mapBranches) {
      await _addMarker(_scaffoldkey, mapBranch);
    }

    dataloaded = true;

    notifyListeners();
  }

  void setRotation(double r) {
    rotation = r;
    notifyListeners();
  }

  Future<void> _addMarker(
      GlobalKey<ScaffoldState> _scaffoldkey, MapBranch element) async {
    Uint8List markerIcon;
    if (element.spec == "restaurant") {
      markerIcon = await getBytesFromAsset(
          'assets/images/ic_quick_link_map_restaurants.png', (SizeConfig.blockSizeHorizontal*50).toInt());
    } else if(element.spec == "coffeeshop"){
      markerIcon =
          await getBytesFromAsset('assets/images/coffee_icon.png', 110);
    }else{
       markerIcon =
          await getBytesFromAsset('assets/images/locationMarkerblue.png', 110);
    }

    final Marker marker = Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          inFocusBranch = element;

          getIt<HOMEMAProvider>().errorController = getIt<HOMEMAProvider>()
              .scaffoldkey
              .currentState
              .showBottomSheet<dynamic>((BuildContext context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          removeLeft: true,
                          removeRight: true,
                          child: MapMerchantCard(branchData: element)),
                    ],
                  ));
        },
        infoWindow: InfoWindow(title: element.merchant.name.toString()));

    markers.add(marker);
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

    specesLoaded = true;
    notifyListeners();
  }
    Future<void> getLocationPics() async {
    final dynamic response = await dio.get<dynamic>("images");
     response.data.forEach((dynamic v) {
        locationPics.add(LocationImages.fromJson(v));
      });
       locationPics.clear();
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
    return specializations.firstWhere((Specialization element) {
      return element.id == selectedSpecialize;
    }).name;
  }

  final PanelController pc = PanelController();
  PersistentBottomSheetController<dynamic> errorController;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  bool specSelected = false;
}
