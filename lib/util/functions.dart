import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/util/dio.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:joker/util/data.dart';

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
  data.setData("lat", locationData.latitude.toString());
  locaion.add(locationData.longitude.toString());
    data.setData("long", locationData.longitude.toString());

  return locaion;
}

Future<bool> get updateLocation async {
  bool res;
  Address first;
  Coordinates coordinates;
  List<Address> addresses;
  config.locationController.text = "getting your location...";

  final List<String> loglat = await getLocation();
  if (loglat.isEmpty) {
    res = false;
  } else {
    config.lat = double.parse(loglat.elementAt(0));
    config.long = double.parse(loglat.elementAt(1));
    res = true;
  }

  try {
    coordinates = Coordinates(
        double.parse(loglat.elementAt(0)), double.parse(loglat.elementAt(1)));
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    data.setData('address', first.toString());
  } catch (e) {
    data.setData('address', "Unkown Location");
  }

  return res;
}

Future<void> getLocationName() async {
  try {
    config.coordinates = Coordinates(config.lat, config.long);
    config.addresses =
        await Geocoder.local.findAddressesFromCoordinates(config.coordinates);
    config.first = config.addresses.first;
    // data.setData('address', config.addresses.first.toString());
    config.first = config.addresses.first;
    config.locationController.text = (config.first == null)
        ? "loading"
        : config.first.addressLine ?? "loading";
  } catch (e) {
    //  data.setData('address', "Unkown Location");
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

Future<bool> likeFunction(String model, int likeId) async {
  bool res;
  await dio.post<dynamic>("likes", data: <String, dynamic>{
    'likable_type': model,
    'likable_id': likeId
  }).then((dynamic value) {
    if (value.data == "true") {
      res = true;
    } else {
      res = false;
    }
  });

  return res;
}

Future<bool> favFunction(String model, int favoriteId) async {
  bool res;
  await dio.post<dynamic>("favorites", data: <String, dynamic>{
    'favoritable_type': model,
    'favoritable_id': favoriteId
  }).then((dynamic value) {
    if (value.data == "true") {
      res = true;
    } else {
      res = false;
    }
  });

  return res;
}
