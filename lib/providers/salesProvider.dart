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
  PagewiseLoadController<dynamic> pagewiseSalesController;
  Future<void> getSale(int saleId) async {
    if (config.loggedin)
      dio.get<dynamic>("sales/$saleId").then((Response<dynamic> value) {});
  }

  SimpleSales merchantSales;

  Future<List<SimpleSalesData>> getSimpleSalesData(
      int pageIndex, int merchantId) async {
    final Response<dynamic> response = await dio.get<dynamic>(
        "simplesales?merchant_id=$merchantId",
        queryParameters: <String, dynamic>{'page': pageIndex});

    merchantSales = SimpleSales.fromJson(response.data);

    return merchantSales.data;
  }

  void setFav(int saleId) {
    sales.data.firstWhere((SaleData element) {
      return element.id == saleId;
    }).isfavorite = 1;
  }

  Future<List<SaleData>> getSalesData(int pageIndex) async {
 
      final Response<dynamic> response =
          await dio.get<dynamic>("psales", queryParameters: <String, dynamic>{
        'page': pageIndex + 1,
        'specifications': getIt<HOMEMAProvider>().selectedSpecialize
      });
      sales = Sales.fromJson(response.data);
 
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
}
