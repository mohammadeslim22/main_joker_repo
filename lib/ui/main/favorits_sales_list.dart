import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/ui/cards/favSaleCard.dart';
import 'package:joker/util/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/constants/colors.dart';

class FavoritDiscountsList extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final HOMEMAProvider value = Provider.of<HOMEMAProvider>(context);

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(waterDropColor: colors.blue),
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
          return Container(height: 55.0, child: Center(child: body));
        },
      ),
      controller: _refreshController,
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));
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
              backgroundColor: Colors.transparent,
            ));
          },
          pageSize: 10,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, dynamic entry, int index) {
            return FadeIn(
                child: FaveCard(sale: entry as SaleData, value: value));
          },
          noItemsFoundBuilder: (BuildContext context) {
            return Text(trans(context, "noting_to_show"));
          },
          pageFuture: (int pageIndex) {
            return getIt<SalesProvider>().getFavoritData(pageIndex);
          }),
    );
  }
}
