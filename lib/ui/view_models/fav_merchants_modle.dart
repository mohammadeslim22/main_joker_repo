import 'package:joker/models/map_branches.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'base_model.dart';

class FavoriteMerchantsModle extends BaseModel {
  List<MapBranch> favbranches = <MapBranch>[];
  PagewiseLoadController<dynamic> pagewiseFavBranchesController;
  Future<List<MapBranch>> getFavoritData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("favorites",
        queryParameters: <String, dynamic>{
          'page': pageIndex + 1,
          'model': "App\\Branch"
        });
    favbranches.clear();
    response.data['data'].forEach((dynamic v) {
      favbranches.add(MapBranch.fromJson(v));
    });
    notifyListeners();
    return favbranches;
  }

  void setFavBraanch(MapBranch temp) {
    try {
      favbranches.add(temp);

      notifyListeners();
    } catch (err) {
      print("error in branch fitch $err");
    }
    notifyListeners();
  }

  void setunFavBranch(int branchId) {
    try {
      favbranches.removeWhere((MapBranch element) => element.id == branchId);
      notifyListeners();
    } catch (err) {
      print("error in branch fitch ");
    }
    notifyListeners();
  }
}
