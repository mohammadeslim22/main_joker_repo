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
import 'package:location/location.dart';
import 'package:joker/constants/config.dart';

class HOMEMAProvider with ChangeNotifier {
  bool dataloaded = false;
  MapBranches branches;
  MapBranch inFocusBranch;
  Location location = Location();
  bool horizentalListOn = false;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Specializations> specializations = <Specializations>[];
  Future<void> getBranchesData(
      GlobalKey<ScaffoldState> _scaffoldkey, double lat, double long,int specId) async {
    await getSpecializationsData();
    final Response<dynamic> response =
        await dio.get<dynamic>("branches/map?long=$long&lat=$lat&specialization_id=$specId");
    branches = MapBranches.fromJson(response.data);
    print("new branches ${branches.mapBranches.length}");
    markers.clear();
    branches.mapBranches.forEach((MapBranch element) async {
      await _addMarker(_scaffoldkey, element);
    });
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/logo.jpg', 100);

    final Marker marker = Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(config.lat ?? 0, config.long ?? 0),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: InfoWindow(
            title: getIt<NavigationService>()
                .translateWithNoContext("your_location")));

    markers[MarkerId('current_location')] = marker;
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

  Future<void> _addMarker(
      GlobalKey<ScaffoldState> _scaffoldkey, MapBranch element) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/locationmarker.png', 100);
    final Marker marker = Marker(
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

    final MarkerId markerId = MarkerId(element.id.toString());
    markers[markerId] = marker;
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
  }
}
