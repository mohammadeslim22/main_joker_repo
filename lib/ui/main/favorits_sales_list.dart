import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/ui/cards/favSaleCard.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/size_config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/constants/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';

class FavoritDiscountsList extends StatefulWidget {
  const FavoritDiscountsList({Key key}) : super(key: key);

  @override
  _FavoritDiscountsListState createState() => _FavoritDiscountsListState();
}

class _FavoritDiscountsListState extends State<FavoritDiscountsList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
        builder: (BuildContext context, SalesProvider value, Widget child) {
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
          value.pagewiseFavSalesController.reset();
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

          // pageSize: 10,
          pageLoadController: value.pagewiseFavSalesController,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, dynamic entry, int index) {
            return FadeIn(child: item(entry as SaleData, value, context));
          },
          noItemsFoundBuilder: (BuildContext context) {
            return Text(trans(context, "nothing_to_show"));
          },
          // pageFuture: (int pageIndex) {
          //   return value.getFavoritData(pageIndex);
          // }
        ),
      );
    });
  }

  Widget item(SaleData sale, SalesProvider value, BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: sale.mainImage,
                        errorWidget:
                            (BuildContext context, String url, dynamic error) {
                          return const Icon(Icons.error);
                        },
                        fit: BoxFit.cover,
                        height: SizeConfig.blockSizeVertical * 8,
                        width: SizeConfig.blockSizeHorizontal * 14,
                      )),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(sale.name, style: styles.saleNameInMapCard),
                        const SizedBox(height: 12),
                        TextOverflowRapper(mytext: sale.details),
                      ],
                    ),
                  ),
                ]),
            LikeButton(
              circleSize: SizeConfig.blockSizeHorizontal * 12,
              size: SizeConfig.blockSizeHorizontal * 7,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              countPostion: CountPostion.bottom,
              circleColor:
                  const CircleColor(start: Colors.blue, end: Colors.purple),
              isLiked: sale.isfavorite == 1,
              onTap: (bool loved) async {
                value.pagewiseFavSalesController.reset();
                print("loved $loved");
                favFunction("App\\Sale", sale.id);
                if (!loved) {
                  value.setFavSale(sale.id);
                } else {
                  value.setunFavSale(sale.id);
                }
                return !loved;
              },
              likeCountPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ]),
    ));
  }
}
