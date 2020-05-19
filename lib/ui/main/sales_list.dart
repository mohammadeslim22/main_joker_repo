import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/counter.dart';
import 'package:flutter/material.dart';
import 'package:joker/ui/cards/sale_card_for_editing_for_shop_merchant_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ui/cards/sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:dio/dio.dart';

class DiscountsList extends StatefulWidget {
  @override
  _DiscountsListState createState() => _DiscountsListState();
}

class _DiscountsListState extends State<DiscountsList> {
  List<SaleData> salesData;
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

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(
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
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: PagewiseListView<dynamic>(
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
                child: SalesCardAfterEditForMerchant(context: context, sale: entry as SaleData));
          },
          pageFuture: (int pageIndex) {
            return getSalesData(pageIndex);
          }),
    );

    // FutureBuilder<List<SaleData>>(
    //     future: getsalesData(),
    //     builder:
    //         (BuildContext ctx, AsyncSnapshot<List<SaleData>> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         print(snapshot.data[0].merchant);
    //         return ListView.builder(
    //             shrinkWrap: true,
    //             physics: const ScrollPhysics(),
    //             padding: const EdgeInsets.all(20),
    //             itemCount: snapshot.data.length,
    //             addRepaintBoundaries: true,
    //             itemBuilder: (BuildContext context, int index) {
    //               return FadeIn(
    //                   child: SalesCard(
    //                       context: context,
    //                       sale: snapshot.data.elementAt(index)));
    //             });
    //       } else {
    //         return const Center(
    //             child: CircularProgressIndicator(
    //           backgroundColor: Colors.transparent,
    //         ));
    //       }
    //     })

    //   );
  }
}
