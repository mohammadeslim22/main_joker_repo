import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/util/size_config.dart';
import '../base_widget.dart';
import 'view_models/favorite_modle.dart';
import 'widgets/favoritetab_bar.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/ui/cards/fav_sale_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/constants/colors.dart';

import 'package:joker/models/map_branches.dart';

import 'package:joker/ui/cards/fav_branch_card.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    return BaseWidget<FavoriteModle>(
        onModelReady: (FavoriteModle modle) {
          modle.favSalesModle.pagewiseFavSalesController =
              PagewiseLoadController<dynamic>(
                  pageSize: 10,
                  pageFuture: (int pageIndex) async {
                    return modle.favSalesModle.getFavoritData(pageIndex);
                  });
          modle.favMerchantssModle.pagewiseFavBranchesController =
              PagewiseLoadController<dynamic>(
                  pageSize: 10,
                  pageFuture: (int pageIndex) async {
                    return modle.favMerchantssModle.getFavoritData(pageIndex);
                  });
        },
        model: getIt<FavoriteModle>(),
        builder: (BuildContext context, FavoriteModle favoritModle,
                Widget child) =>
            Scaffold(
                appBar: AppBar(
                    title: Text(trans(context, "fav"), style: styles.appBars),
                    centerTitle: true,
                    bottom: PreferredSize(
                      preferredSize:
                          Size.fromHeight(SizeConfig.blockSizeVertical * 6),
                      child: FavoritBar(favoritModle: favoritModle),
                    )),
                body: Container(
                    color: colors.white,
                    child: (favoritModle.favocurrentIndex == 0)
                        ? SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header:
                                WaterDropHeader(waterDropColor: colors.orange),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = Text(trans(context, "pull_up_load"));
                                } else if (mode == LoadStatus.loading) {
                                  body = const CupertinoActivityIndicator();
                                } else {
                                  body = const Text("No more Data");
                                }
                                return Container(
                                    height: 55.0, child: Center(child: body));
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: () async {
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 1000));
                              _refreshController.refreshCompleted();
                            },
                            onLoading: () async {
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 1000));

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
                              pageLoadController: favoritModle
                                  .favMerchantssModle
                                  .pagewiseFavBranchesController,
                              padding: const EdgeInsets.all(15.0),
                              itemBuilder: (BuildContext context, dynamic entry,
                                  int index) {
                                return FadeIn(
                                    child: FaveBranchCard(
                                        branch: entry as MapBranch,
                                        resetForUnFav: () {
                                          favoritModle.favMerchantssModle
                                              .pagewiseFavBranchesController
                                              .reset();
                                        }));
                              },
                              noItemsFoundBuilder: (BuildContext context) {
                                return Text(trans(context, "no_fav_saved"));
                              },
                            ))
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header:
                                WaterDropHeader(waterDropColor: colors.blue),
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
                                return Container(
                                    height: 55.0, child: Center(child: body));
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: () async {
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 1000));
                              favoritModle
                                  .favSalesModle.pagewiseFavSalesController
                                  .reset();
                              _refreshController.refreshCompleted();
                            },
                            onLoading: () async {
                              await Future<void>.delayed(
                                  const Duration(milliseconds: 1000));
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
                              pageLoadController: favoritModle
                                  .favSalesModle.pagewiseFavSalesController,
                              padding: const EdgeInsets.all(15.0),
                              itemBuilder: (BuildContext contextt,
                                  dynamic entry, int index) {
                                return FadeIn(
                                    child: FaveCard(
                                        sale: entry as SaleData,
                                        resetForunFav: () {
                                          favoritModle.favSalesModle
                                              .pagewiseFavSalesController
                                              .reset();
                                        }));
                              },
                              noItemsFoundBuilder: (BuildContext context) {
                                return Text(trans(context, "nothing_to_show"));
                              },
                            )))));
  }
}
