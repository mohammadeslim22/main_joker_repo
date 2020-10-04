import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:joker/util/service_locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ui/cards/sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/providers/globalVars.dart';

class DiscountsList extends StatefulWidget {
  const DiscountsList({Key key}) : super(key: key);
  // final FilterData filterData;
  @override
  _DiscountsListState createState() => _DiscountsListState();
}

class _DiscountsListState extends State<DiscountsList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getIt<SalesProvider>().pagewiseSalesController =
        PagewiseLoadController<dynamic>(
            pageSize: 5,
            pageFuture: (int pageIndex) async {
              return (getIt<GlobalVars>().filterData != null)
                  ? getIt<SalesProvider>().getSalesDataFilterd(
                      pageIndex, getIt<GlobalVars>().filterData)
                  : getIt<SalesProvider>().getSalesData(pageIndex);
            });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(
        complete: Container(),
        waterDropColor: colors.blue,
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
        getIt<SalesProvider>().salesLoaded = false;
        getIt<SalesProvider>().pagewiseSalesController.reset();
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
        pageLoadController: getIt<SalesProvider>().pagewiseSalesController,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, dynamic entry, int index) {
          return FadeIn(child: SalesCard(sale: entry as SaleData));
        },
        noItemsFoundBuilder: (BuildContext context) {
          return Text(trans(context, "noting_to_show"));
        },
      ),
    );
  }
}
