import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/constants/config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HOMEMAProvider with ChangeNotifier {
  bool dataloaded = false;
  MapBranches branches;
  MapBranch inFocusBranch;
  bool horizentalListOn = false;
  double rotation;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Marker> markers = <Marker>[];
  List<Specializations> specializations = <Specializations>[];
  double bottomSheetheight = 200;
  int selectedSpecialize;
  Future<void> getBranchesData(GlobalKey<ScaffoldState> _scaffoldkey,
      double lat, double long, int specId) async {
    // await getSpecializationsData();
    final Response<dynamic> response = await dio
        .get<dynamic>("map?long=$long&lat=$lat&specialization_id=$specId");
    branches = MapBranches.fromJson(response.data);
    markers.clear();
    branches.mapBranches.forEach((MapBranch element) async {
      await _addMarker(_scaffoldkey, element);
    });
    Uint8List markerIcon =
        await getBytesFromAsset('assets/images/locationMarkerblue.png', 100);
    Marker marker = Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(config.lat ?? 0, config.long ?? 0),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: InfoWindow(
            title: getIt<NavigationService>()
                .translateWithNoContext("your_location")),
        rotation: rotation,
        flat: true);
    markers.add(marker);
    // markers[MarkerId('current_location')] = marker;
    dataloaded = true;
    if (branches.mapBranches.isEmpty) {
      getIt<HOMEMAProvider>().showHorizentalListOrHideIt(false);
    }
    notifyListeners();
  }

  void showHorizentalListOrHideIt(bool state) {
    horizentalListOn = state;
    notifyListeners();
  }

  void setRotation(double r) {
    rotation = r;
    notifyListeners();
  }

  Future<void> _addMarker(
      GlobalKey<ScaffoldState> _scaffoldkey, MapBranch element) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/locationMarkerblue.png', 100);
    Marker marker = Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          inFocusBranch = element;
          getIt<HOMEMAProvider>().showHorizentalListOrHideIt(true);
        },
        infoWindow: InfoWindow(
          title: element.merchant.name.toString(),
        ));

    // final MarkerId markerId = MarkerId(element.id.toString());
    // markers[markerId] = marker;
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
    response.data.forEach((dynamic element) {
      specializations.add(Specializations.fromJson(element));
    });
    notifyListeners();
  }

  void setSlelectedSpec(int id) {
    selectedSpecialize = id;
    notifyListeners();
  }

  String getSpecializationName() {
    return specializations.firstWhere((Specializations element) {
      return element.id == selectedSpecialize;
    }).name;
  }
  final PanelController pc = PanelController();
  PersistentBottomSheetController<dynamic> errorController;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  
  
}
