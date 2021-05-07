import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/models/simplesales.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/service_locator.dart';

import 'map_provider.dart';

class SalesProvider with ChangeNotifier {
  Sales sales;
  Sales tempSales;
  Sales merchantSales;
  PagewiseLoadController<dynamic> pagewiseSalesController;
    PagewiseLoadController<dynamic> pagewiseHomeSalesController;

  PagewiseLoadController<dynamic> pagewiseFavSalesController;
  FilterData filterData;
  void setFilterDate(FilterData data) {
    filterData = data;
    notifyListeners();
  }

  void clearilterDate() {
    filterData = FilterData(
        merchantNameOrPartOfit: "",
        saleNameOrPartOfit: "",
        specifications: <int>[1, 2],
        startingdate: DateTime(2020),
        endingdate: DateTime(2900),
        fromPrice: 0,
        toPrice: 99999);
    notifyListeners();
  }
  // Sales favSales ;
  List<SaleData> favSales = <SaleData>[];
  Future<void> getSale(int saleId) async {
    // if (config.loggedin)
    if (getIt<Auth>().isAuthintecated)
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
    favSales.clear();
    response.data['data'].forEach((dynamic v) {
      favSales.add(SaleData.fromJson(v));
    });
    notifyListeners();
    // favSales = Sales.fromJson(response.data);
    return favSales;
  }

  Future<List<SaleData>> getMerchantSalesData(
      int pageIndex, int merchantId) async {
    final Response<dynamic> response = await dio.get<dynamic>(
        "sales?merchant_id=$merchantId",
        queryParameters: <String, dynamic>{'page': pageIndex + 1});

    merchantSales = Sales.fromJson(response.data);

    return merchantSales.data;
  }

  void setFavSale(int saleId, {int bId}) {
    try {
      if (bId != null) {
        getIt<HOMEMAProvider>()
            .branches
            .mapBranches
            .firstWhere((MapBranch element) {
              return element.id == bId;
            })
            .lastsales
            .firstWhere((SaleData element) {
              return element.id == saleId;
            })
            .isfavorite = 1;
      }
      favSales.add(sales.data.firstWhere((SaleData element) {
        return element.id == saleId;
      }));
      if (sales != null)
        sales.data.firstWhere((SaleData element) {
          return element.id == saleId;
        }).isfavorite = 1;
      notifyListeners();
    } catch (err) {
      print("could not find element");
    }
  }

  void setunFavSale(int saleId, {int bId}) {
    try {
      if (bId != null) {
        getIt<HOMEMAProvider>()
            .branches
            .mapBranches
            .firstWhere((MapBranch element) {
              return element.id == bId;
            })
            .lastsales
            .firstWhere((SaleData element) {
              return element.id == saleId;
            })
            .isfavorite = 1;
      }
      print("step in");
      if (sales != null) {
        sales.data.firstWhere((SaleData element) {
          return element.id == saleId;
        }).isfavorite = 0;
        print("step in try");
      }

      favSales.removeWhere((SaleData element) => element.id == saleId);
      print("step out ");
      notifyListeners();
    } catch (err) {
      print("orrrrr");
    }
  }

  void setLikeSale(int saleId) {
    try {
      if (sales != null)
        sales.data.firstWhere((SaleData element) {
          return element.id == saleId;
        }).isliked = 1;
      notifyListeners();
    } catch (err) {
      print("could not find element");
    }
  }

  void setunLikeSale(int saleId) {
    try {
      if (sales != null)
        sales.data.firstWhere((SaleData element) {
          return element.id == saleId;
        }).isliked = 0;
      notifyListeners();
    } catch (err) {
      print("orrrrr");
    }
  }

  Future<List<SaleData>> getSalesData(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("psales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization':
          jsonEncode(<int>[getIt<HOMEMAProvider>().selectedSpecialize ?? 1])
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataAuthenticated(int pageIndex) async {
    print("page index $pageIndex");
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization':
          jsonEncode(<int>[getIt<HOMEMAProvider>().selectedSpecialize])
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataFilterd(
      int pageIndex, FilterData filterData) async {
    // String spec = "";
    // filterData.specifications.forEach((int element) {
    //   if (element == filterData.specifications.last) {
    //     spec = spec + element.toString();
    //   } else {
    //     spec = spec + element.toString() + ",";
    //   }
    //   print("spec $spec");
    // });

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(filterData.startingdate);
    final String endDate = formatter.format(filterData.endingdate);
    final Response<dynamic> response =
        await dio.get<dynamic>("psales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'merchant_name': filterData.merchantNameOrPartOfit,
      'name': filterData.saleNameOrPartOfit,
      'from_date': startDate,
      'to_date': endDate,
      'rate': filterData.rating,
      'specifications': jsonEncode(filterData.specifications)
    });
    sales = Sales.fromJson(response.data);
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataFilterdAuthenticated(
      int pageIndex, FilterData filterData) async {
    // String spec = "";
    // filterData.specifications.forEach((int element) {
    //   if (element == filterData.specifications.last) {
    //     spec = spec + element.toString();
    //   } else {
    //     spec = spec + element.toString() + ",";
    //   }
    //   print("spec $spec");
    // });
    print(jsonEncode(filterData.specifications));
    print(
        "filterData  ${filterData.merchantNameOrPartOfit} ${filterData.saleNameOrPartOfit} ${filterData.fromPrice} ${filterData.specifications} ${filterData.startingdate}");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate = formatter.format(filterData.startingdate);
    final String endDate = formatter.format(filterData.endingdate);
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'merchant_name': filterData.merchantNameOrPartOfit.isEmpty
          ? ""
          : filterData.merchantNameOrPartOfit,
      'name': filterData.saleNameOrPartOfit.isNotEmpty
          ? filterData.saleNameOrPartOfit
          : "",
      'from_date': startDate,
      'to_date': endDate,
      'from_price': filterData.fromPrice,
      'to_price': filterData.toPrice,
      'specialization': jsonEncode(filterData.specifications)
    });

    // print(response.data);
    sales = Sales.fromJson(response.data);
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataAllSpec(int pageIndex) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("psales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization': jsonEncode(<int>[1, 2, 3, 4, 5])
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;
    notifyListeners();
    return sales.data;
  }

  Future<List<SaleData>> getSalesDataAuthenticatedAllSpec(int pageIndex) async {
    print("page index $pageIndex");
    final Response<dynamic> response =
        await dio.get<dynamic>("sales", queryParameters: <String, dynamic>{
      'page': pageIndex + 1,
      'specialization': jsonEncode(<int>[1, 2, 3, 4, 5])
    });
    sales = Sales.fromJson(response.data);
    tempSales = sales;
    notifyListeners();
    return sales.data;
  }
}
