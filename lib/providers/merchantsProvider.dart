import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/models/merchant.dart' as merchant_main_model;
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/models/branches_model.dart';
import 'package:joker/util/service_locator.dart';
import 'map_provider.dart';

class MerchantProvider with ChangeNotifier {
  merchant_main_model.Merchant merchant;
  Branches branches;
  List<MapBranch> favbranches;

  PagewiseLoadController<dynamic> pagewiseBranchesController;

  Future<merchant_main_model.Merchant> getMerchantData(
      int id, String source, int ignore) async {
    final dynamic response = await dio.get<dynamic>("merchants/$id",
        queryParameters: <String, dynamic>{"source": source, "ignore": ignore});
    merchant = merchant_main_model.Merchant.fromJson(response.data);
    notifyListeners();
    return merchant;
  }

  Future<List<BranchData>> getBranchesData(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("pbranches", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization':
          jsonEncode(<int>[getIt<HOMEMAProvider>().selectedSpecialize])
    });

    branches = Branches.fromJson(response.data);
    // branches.data.forEach((BranchData element) {
    //   print("branch no auth ${element.id}");
    // });
    notifyListeners();
    return branches.data;
  }

  Future<List<BranchData>> getBranchesDataAuthintecated(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("branches", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization':
          jsonEncode(<int>[getIt<HOMEMAProvider>().selectedSpecialize])
    });
    branches = Branches.fromJson(response.data);
    // branches.data.forEach((BranchData element) {
    //   print("branch auth -- ${element.id}");
    // });
    notifyListeners();

    return branches.data;
  }

  Future<List<MapBranch>> getFavoritData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("favorites",
        queryParameters: <String, dynamic>{
          'page': pageIndex + 1,
          'model': "App\\Branch"
        });
    response.data['data'].forEach((dynamic v) {
      favbranches.add(MapBranch.fromJson(v));
    });

    MapBranch.fromJson(response.data);
    notifyListeners();
    return favbranches;
  }

  Future<void> vistBranch(int branchId, {String source = 'click'}) async {
    print(await dio.get<dynamic>("branches/$branchId",
        queryParameters: <String, String>{'source': 'qr'}));
  }

  void setFavBraanch(int branchId) {
    print(branches.data);
    try {
      branches.data.firstWhere((BranchData element) {
        return element.id == branchId;
      }).isfavorite = 1;
      notifyListeners();
    } catch (err) {
      print("error in branch fitch $err");
    }
    notifyListeners();
  }

  void setunFavBranch(int branchId) {
    try {
      branches.data.firstWhere((BranchData element) {
        return element.id == branchId;
      }).isfavorite = 1;
      notifyListeners();
    } catch (err) {
      print("error in branch fitch ");
    }
    notifyListeners();
  }

  String getMerchantMainPhoto(int merchantId) {
    return branches.data
        .firstWhere((BranchData element) {
          return element.merchant.id == merchantId;
        })
        .merchant
        .logo;
  }

  String getMerchantMainNme(int merchantId) {
    return branches.data
        .firstWhere((BranchData element) {
          return element.merchant.id == merchantId;
        })
        .merchant
        .name;
  }

  double getMerchantRatesAverage(int merchantId) {
    return branches.data
        .firstWhere((BranchData element) {
          return element.merchant.id == merchantId;
        })
        .merchant
        .rateAverage;
  }
}
