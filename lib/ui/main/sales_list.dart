import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/providers/counter.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ui/cards/sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class DiscountsList extends StatefulWidget {
  const DiscountsList({Key key, this.filterData}) : super(key: key);
  final FilterData filterData;
  @override
  _DiscountsListState createState() => _DiscountsListState();
}

class _DiscountsListState extends State<DiscountsList> {
  Sales sale;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MyCounter bolc;

  Future<List<SaleData>> getSalesData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("sales",
        queryParameters: <String, dynamic>{'page': pageIndex + 1});
    sale = Sales.fromJson(response.data);
    return sale.data;
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
    sale = Sales.fromJson(response.data);
    return sale.data;
  }

  PagewiseLoadController<dynamic> _pagewiseController;

  @override
  void initState() {
    _pagewiseController = PagewiseLoadController<dynamic>(
        pageSize: 3,
        pageFuture: (int pageIndex) async {
          return getSalesData(pageIndex);
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(
        complete: Container(),
        waterDropColor: Colors.orange,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: () async {
        _pagewiseController.reset();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          setState(() {});
          _refreshController.loadComplete();
        }
      },
      child: PagewiseListView<dynamic>(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        loadingBuilder: (BuildContext context) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
          ));
        },
        // pageSize: 10,
        pageLoadController: _pagewiseController,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, dynamic entry, int index) {
          return FadeIn(
              child: SalesCard(context: context, sale: entry as SaleData));
        },
        noItemsFoundBuilder: (BuildContext context) {
          return Text(trans(context, "noting_to_show"));
        },
        // pageFuture: (int pageIndex) {
        //   //  return getSalesDataFilterd(pageIndex, widget.filterData);
        //   return (widget.filterData != null)
        //       ? getSalesDataFilterd(pageIndex, widget.filterData)
        //       : getSalesData(pageIndex);
        // },
      ),
    );
  }
}
