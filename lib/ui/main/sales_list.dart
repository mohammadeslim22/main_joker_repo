import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
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
  const DiscountsList({Key key, this.filterData})
      : super(key: key);
 // final bool saleDataFilter;
  final FilterData filterData;
  @override
  _DiscountsListState createState() => _DiscountsListState();
}

class _DiscountsListState extends State<DiscountsList> {
  Sales sale;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MyCounter bolc;

  // Future<List<SaleData>> getSalesData(int pageIndex) async {
  //   print("am getting default sales ");
  //   final Response<dynamic> response = await dio.get<dynamic>("sales",
  //       queryParameters: <String, dynamic>{'page': pageIndex + 1});
  //   sale = Sales.fromJson(response.data);
  //   return sale.data;
  // }

  Future<List<SaleData>> getSalesDataFilterd(
      int pageIndex, FilterData filterData) async {
        final DateFormat formatter =  DateFormat('yyyy-MM-dd');
  final String startDate = formatter.format(filterData.startingdate);
    final String endDate = formatter.format(filterData.endingdate);

        print(filterData.toString());
        print("$startDate   + $endDate");
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
    print(response.data);
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
  void initState() {
    super.initState();
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
                child: SalesCard(context: context, sale: entry as SaleData));
          },
          pageFuture: (int pageIndex) {
            // return widget.saleDataFilter
            //     ? getSalesDataFilterd(pageIndex, widget.filterData)
            //     : getSalesData(pageIndex);
           return  getSalesDataFilterd(pageIndex, widget.filterData);
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
