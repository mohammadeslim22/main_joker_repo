

import 'package:location/location.dart';

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

  