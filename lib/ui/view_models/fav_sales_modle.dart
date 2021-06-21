import 'base_model.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'package:joker/models/sales.dart';

import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';

class FavoriteSalesModle extends BaseModel {
  PagewiseLoadController<dynamic> pagewiseFavSalesController;
  List<SaleData> favSales = <SaleData>[];

  Future<List<SaleData>> getFavoritData(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("favorites", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'model': 'App\\Sale',
    });
    favSales.clear();
    response.data['data'].forEach((dynamic v) {
      favSales.add(SaleData.fromJson(v));
    });
    notifyListeners();
    return favSales;
  }

  void setFavSale(SaleData sale) {
    try {
      favSales.add(sale);

      notifyListeners();
    } catch (err) {
      print("could not find element");
    }
  }

  void setunFavSale(int saleId, {int bId}) {
    try {
      favSales.removeWhere((SaleData element) => element.id == saleId);
      print("step out ");
      notifyListeners();
    } catch (err) {
      print("orrrrr");
    }
  }
}
