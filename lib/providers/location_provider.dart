import 'package:flutter/material.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/models/locations.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class LocationProvider with ChangeNotifier {
  Locations locations;
  PagewiseLoadController<dynamic> pagewiseLocationController;

  Future<List<LocationsData>> getAddressData(int page) async {
    final dynamic response =
        await dio.get<dynamic>("locations", queryParameters: <String, dynamic>{
      'page': page + 1,
    });
    locations = Locations.fromJson(response.data);
    return locations.data;
  }

  void saveLocation(String address, double lat, double long) {
    dio.post<dynamic>("locations", data: <String, dynamic>{
      'address': address ?? "Unknown",
      'latitude': lat,
      'longitude': long
    });
  }
}
