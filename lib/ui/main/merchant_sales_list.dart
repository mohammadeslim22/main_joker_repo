import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:flutter/material.dart';
import 'package:joker/ui/cards/sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:dio/dio.dart';

class MerchantSalesList extends StatefulWidget {
  const MerchantSalesList({Key key, this.merchantId}) : super(key: key);

  @override
  _MerchantSalesListState createState() => _MerchantSalesListState();
  final int merchantId;
}

class _MerchantSalesListState extends State<MerchantSalesList> {
  Sales sale;

  MainProvider bolc;
  Future<List<SaleData>> getSalesData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("sales?merchant_id=${widget.merchantId}", queryParameters:<String, dynamic> {'page': pageIndex+1});

    sale = Sales.fromJson(response.data);

    return sale.data;
  }

  @override
  Widget build(BuildContext context) {
    return PagewiseListView<dynamic>(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        loadingBuilder: (BuildContext context) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
          ));
        },
        pageSize: 10,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, dynamic entry, int index) {
          return FadeIn(
              child: SalesCard( sale: entry as SaleData));
        },
        pageFuture: (int pageIndex) {
          return getSalesData(pageIndex);
        });
  }
}
