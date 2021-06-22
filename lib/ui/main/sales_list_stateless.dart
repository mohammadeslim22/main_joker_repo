import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/service_locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../base_widget.dart';
import '../cards/sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/providers/salesProvider.dart';

class DiscountsListStateless extends StatelessWidget {
  DiscountsListStateless({Key key}) : super(key: key);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SalesProvider>(
        onModelReady: (SalesProvider modle) {
          print("salesDataFilter ${modle.salesDataFilter}");
          modle.pagewiseHomeSalesController = PagewiseLoadController<dynamic>(
              pageSize: getIt<Auth>().isAuthintecated ? 15 : 6,
              pageFuture: (int pageIndex) async {
                return getIt<Auth>().isAuthintecated
                    ? modle.salesDataFilter
                        ? modle.getSalesDataFilterdAuthenticated(
                            pageIndex, modle.filterData)
                        : modle.getSalesDataAuthenticatedAllSpec(pageIndex)
                    : modle.salesDataFilter
                        ? modle.getSalesDataFilterd(pageIndex, modle.filterData)
                        : modle.getSalesDataAllSpec(pageIndex);
              });
        },
        model: getIt<SalesProvider>(),
        builder: (BuildContext context, SalesProvider modle, Widget child) =>
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                  complete: Container(), waterDropColor: colors.orange),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text(trans(context, "pull_up_load"));
                  } else if (mode == LoadStatus.loading) {
                    body = const CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = const Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = const Text("release to load more");
                  } else {
                    body = const Text("No more Data");
                  }
                  return Container(height: 55.0, child: Center(child: body));
                },
              ),
              controller: _refreshController,
              onRefresh: () async {
                modle.pagewiseHomeSalesController.reset();
                _refreshController.refreshCompleted();
              },
              onLoading: () async {
                await Future<void>.delayed(const Duration(milliseconds: 1000));

                _refreshController.loadComplete();
              },
              child: PagewiseListView<dynamic>(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                loadingBuilder: (BuildContext context) {
                  return const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent));
                },
                pageLoadController: modle.pagewiseHomeSalesController,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (BuildContext context, dynamic entry, int index) {
                  return FadeIn(child: SalesCard(sale: entry as SaleData));
                },
                noItemsFoundBuilder: (BuildContext context) {
                  return Text(trans(context, "nothing_to_show"));
                },
              ),
            ));
  }
}
