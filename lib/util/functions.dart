import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/util/dio.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/providers/merchantsProvider.dart';

final Location location = Location();

Future<List<String>> getLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  final List<String> locaion = <String>[];
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
  content: const Text("Location Service was not alowed  !"),
  action: SnackBarAction(
    label: 'Ok !',
    onPressed: () {},
  ),
);
SpinKitRing spinkit = SpinKitRing(
  color: colors.jokerBlue,
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
      getIt<MerchantProvider>().setFav(favoriteId);
      res = true;
    } else {
      res = false;
    }
  });

  return res;
}

Future<bool> onWillPop(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(trans(context, 'are_u_sure')),
          content: Text(trans(context, 'do_u_want_to_exit')),
          actionsOverflowButtonSpacing: 50,
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(trans(context, 'cancel')),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(trans(context, 'ok')),
            ),
          ],
        ),
      )) ??
      false;
}

void goToMap(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, "/WhereToGo", (_) => false);
  // arguments: <String, dynamic>{
  //   "home_map_lat": config.lat ?? 0.0,
  //   "home_map_long": config.long ?? 0.0
  // });
}
