import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/models/merchant.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/models/branches_model.dart';
import 'package:joker/util/service_locator.dart';
import 'map_provider.dart';

class MerchantProvider with ChangeNotifier {
  Merchant merchant;
  Branches branches;
  PagewiseLoadController<dynamic> pagewiseBranchesController;

  Future<void> getMerchantData(int id, String source, int ignore) async {
    final dynamic response = await dio.get<dynamic>("merchants/$id",
        queryParameters: <String, dynamic>{"source": source, "ignore": ignore});
    merchant = Merchant.fromJson(response.data);
    notifyListeners();
  }

  Future<List<BranchData>> getBranchesData(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("branches", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization': <int>[getIt<HOMEMAProvider>().selectedSpecialize]
    });

    branches = Branches.fromJson(response.data);
    return branches.data;
  }

  Future<void> vistBranch(int branchId, {String source = 'click'}) async {
    print(await dio.get<dynamic>("branches/$branchId",
        queryParameters: <String, String>{'source': 'qr'}));
  }

  void setFav(int branchId) {
    branches.data.firstWhere((BranchData element) {
      return element.id == branchId;
    }).isfavorite = 1;
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
