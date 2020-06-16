import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/util/dio.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

Future<List<String>> getLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  final List<String> locaion = <String>[];
  final Location location = Location();
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return locaion;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return locaion;
    }
  }

  locationData = await location.getLocation();
  locaion.add(locationData.latitude.toString());
  locaion.add(locationData.longitude.toString());
  return locaion;
}

Future<bool> get updateLocation async {
  bool res;

  config.locationController.text = "getting your location...";

  final List<String> loglat = await getLocation();
  if (loglat.isEmpty) {
    res = false;
  } else {
    config.lat = double.parse(loglat.elementAt(0));
    config.long = double.parse(loglat.elementAt(1));
    res = true;
  }
  return res;
}
// class MyObject{
//    MyObject(this.location2);
//   final List<String> location2;
//   final

// }
Future<void> getLocationName() async {
  try {
    config.coordinates = Coordinates(config.lat, config.long);
    config.addresses =
        await Geocoder.local.findAddressesFromCoordinates(config.coordinates);
    config.first = config.addresses.first;

    config.first = config.addresses.first;
    config.locationController.text = (config.first == null)
        ? "loading"
        : config.first.addressLine ?? "loading";
  } catch (e) {
    config.locationController.text =
        "Unkown latitude: ${config.lat.round().toString()} , longitud: ${config.long.round().toString()}";
  }
}

SnackBar snackBar = SnackBar(
  content: const Text("Location Service was not aloowed  !"),
  action: SnackBarAction(
    label: 'Ok !',
    onPressed: () {},
  ),
);
SpinKitRing spinkit = const SpinKitRing(
  color: Colors.orange,
  size: 30.0,
  lineWidth: 3,
);

Future<dynamic> likeFunction( String model, int likeId) async {
 return  await dio.post<dynamic>("likes", data: <String, dynamic>{
    
    'likable_type': model,
    'likable_id': likeId
  });
}
Future<dynamic> favFunction(String model, int favoriteId) async {
 return  await dio.post<dynamic>("favorites", data: <String, dynamic>{
    
    'favoritable_type': model,
    'favoritable_id': favoriteId
  });
}
