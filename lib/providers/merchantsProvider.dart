import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/models/merchant.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/models/branches_model.dart';

class MerchantProvider with ChangeNotifier {
  Merchant merchant;
  Branches branches;
  PagewiseLoadController<dynamic>pagewiseBranchesController;

  Future<void> getMerchantData(int id, String source) async {
    final dynamic response = await dio.get<dynamic>("merchants/$id",
        queryParameters: <String, dynamic>{"source": source});
    merchant = Merchant.fromJson(response.data);
    notifyListeners();
  }

  Future<List<BranchData>> getBranchesData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("branches",
        queryParameters: <String, dynamic>{'page': pageIndex + 1});
    print(response.data);
    branches = Branches.fromJson(response.data);
    return branches.data;
  }

  void setFav(int branchId) {
    branches.data.firstWhere((BranchData element) {
      return element.id == branchId;
    }).isfavorite=1;
  }
}
