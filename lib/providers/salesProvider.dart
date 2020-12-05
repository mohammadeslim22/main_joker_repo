import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/models/simplesales.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/util/service_locator.dart';

import 'map_provider.dart';

class SalesProvider with ChangeNotifier {
  Sales sales;
  Sales tempSales;
  Sales merchantSales;
  PagewiseLoadController<dynamic> pagewiseSalesController;
  Sales favSales;
  Future<void> getSale(int saleId) async {
    if (config.loggedin)
      dio.get<dynamic>("sales/$saleId").then((Response<dynamic> value) {});
  }

  SimpleSales simplemMerchantSales;

  Future<List<SimpleSalesData>> getSimpleSalesData(
      int pageIndex, int merchantId) async {
    final Response<dynamic> response = await dio.get<dynamic>(
        "simplesales?merchant_id=$merchantId",
        queryParameters: <String, dynamic>{'page': pageIndex});

    simplemMerchantSales = SimpleSales.fromJson(response.data);

    return simplemMerchantSales.data;
  }

  Future<List<SaleData>> getFavoritData(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("favorites", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'model': 'App\\Sale',
    });
    favSales = Sales.fromJson(response.data);
    return favSales.data;
  }

  Future<List<SaleData>> getMerchantSalesData(
      int pageIndex, int merchantId) async {
    final Response<dynamic> response = await dio.get<dynamic>(
        "sales?merchant_id=$merchantId",
        queryParameters: <String, dynamic>{'page': pageIndex + 1});

    merchantSales = Sales.fromJson(response.data);

    return merchantSales.data;
  }

  void setFavSale(int saleId) {
    try {
      sales.data.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isfavorite = 1;
      notifyListeners();
    } catch (err) {
      print("could not find element");
    }
  }

  void setunFavSale(int saleId) {
    print(saleId);
    try {
      sales.data.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isfavorite = 0;
      notifyListeners();
    } catch (err) {
      print("orrrrr");
    }
  }
  void setLikeSale(int saleId) {
    try {
      sales.data.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isliked = 1;
      notifyListeners();
    } catch (err) {
      print("could not find element");
    }
  }

  void setunLikeSale(int saleId) {
    print(saleId);
    try {
      sales.data.firstWhere((SaleData element) {
        return element.id == saleId;
      }).isliked = 0;
      notifyListeners();
    } catch (err) {
      print("orrrrr");
    }
  }
  Future<List<SaleData>> getSalesData(int pageIndex) async {
    print("page index $pageIndex");
    final Response<dynamic> response =
        await dio.get<dynamic>("psales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization': <int>[getIt<HOMEMAProvider>().selectedSpecialize]
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;

    return sales.data;
  }

  Future<List<SaleData>> getSalesDataAuthenticated(int pageIndex) async {
    print("page index $pageIndex");
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization': <int>[getIt<HOMEMAProvider>().selectedSpecialize]
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;

    return sales.data;
  }

  Future<List<SaleData>> getSalesDataFilterd(
      int pageIndex, FilterData filterData) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(filterData.startingdate);
    final String endDate = formatter.format(filterData.endingdate);
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'merchant_name': filterData.merchantNameOrPartOfit,
      'name': filterData.saleNameOrPartOfit,
      'from_date': startDate,
      'to_date': endDate,
      'rate': filterData.rating,
      'specifications': filterData.specifications
    });
    sales = Sales.fromJson(response.data);
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataFilterdAuthenticated(
      int pageIndex, FilterData filterData) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(filterData.startingdate);
    final String endDate = formatter.format(filterData.endingdate);
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'merchant_name': filterData.merchantNameOrPartOfit,
      'name': filterData.saleNameOrPartOfit,
      'from_date': startDate,
      'to_date': endDate,
      'rate': filterData.rating,
      'specifications': filterData.specifications
    });
    sales = Sales.fromJson(response.data);
    return sales.data;
  }
}
