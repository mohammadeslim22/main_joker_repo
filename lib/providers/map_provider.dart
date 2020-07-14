import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/models/branches_model.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/models/specializations.dart';
import 'package:location/location.dart';

class HOMEMAProvider with ChangeNotifier {
  bool dataloaded = false;
  Branches branches;
  Location location = Location();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Specializations> specializations = <Specializations>[];
  Future<void> getBranchesData() async {
    await getSpecializationsData();
    final Response<dynamic> response = await dio.get<dynamic>("branches");
    print(response.data);
    branches = Branches.fromJson(response.data);
    branches.data.forEach((BranchData element) async {
      await _addMarker(element);
    });

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/logo.jpg', 100);
    await location.getLocation().then((LocationData value) {
      location.onLocationChanged.listen((LocationData value) {
        final Marker marker = Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(value.latitude, value.longitude),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(
                title: getIt<NavigationService>()
                    .translateWithNoContext("your_location")));

        markers[MarkerId('current_location')] = marker;
      });
    });

    dataloaded = true;
    notifyListeners();
  }

  Future<void> _addMarker(BranchData element) async {
    print("=========MarkerID : ${element.id}==========");
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/locationmarker.png', 100);
    final Marker marker = Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          getIt<NavigationService>().navigateToNamed(
            "/MerchantDetails",
            <String, dynamic>{
              "merchantId": element.merchant.id,
              "branchId": element.id
            },
          );
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
