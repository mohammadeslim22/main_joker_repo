import 'package:flutter/cupertino.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/branches_model.dart';
import 'package:flutter/material.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:joker/util/service_locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../cards/merchant_card.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class ShopListStaeless extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropMaterialHeader(color: Colors.white, offset: 00),
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
        getIt<MerchantProvider>().pagewiseBranchesController.reset();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));

        _refreshController.loadComplete();
      },
      child: PagewiseListView<dynamic>(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        pageLoadController:
            getIt<MerchantProvider>().pagewiseBranchesController,
        loadingBuilder: (BuildContext context) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
          ));
        },
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, dynamic entry, int index) {
          return FadeIn(child: MerchantCard(branchData: entry as BranchData));
        },
        noItemsFoundBuilder: (BuildContext context) {
          return Text(trans(context, "noting_to_show"));
        },
      ),
    );
  }
}
