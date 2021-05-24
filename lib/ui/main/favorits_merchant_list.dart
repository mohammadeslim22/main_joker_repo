import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:flutter/material.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/ui/cards/fav_branch_card.dart';
import 'package:provider/provider.dart';

class FavoritMerchantsList extends StatelessWidget {
  FavoritMerchantsList({Key key}) : super(key: key);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantProvider>(
        builder: (BuildContext context, MerchantProvider value, Widget child) {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(waterDropColor: colors.orange),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
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
                      backgroundColor: Colors.transparent));
            },
            pageSize: 10,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, dynamic entry, int index) {
              return FadeIn(
                  child:
                      FaveBranchCard(branch: entry as MapBranch, value: value));
            },
            noItemsFoundBuilder: (BuildContext context) {
              return Text(trans(context, "no_fav_saved"));
            },
            pageFuture: (int pageIndex) {
              return value.getFavoritData(pageIndex);
            }),
      );
    });
  }
}
