import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:joker/util/service_locator.dart';
import '../../ui/cards/map_sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/providers/salesProvider.dart';

class MapSalesListState extends StatelessWidget {
  const MapSalesListState({Key key, this.sc, this.close}) : super(key: key);
  final ScrollController sc;
  final Function close;

  @override
  Widget build(BuildContext context) {
    return PagewiseListView<dynamic>(
      physics: const ScrollPhysics(),
      controller: sc,
      shrinkWrap: true,
      loadingBuilder: (BuildContext context) {
        return const Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.transparent));
      },
      pageLoadController: getIt<SalesProvider>().pagewiseSalesController,
      padding: const EdgeInsets.all(6.0),
      itemBuilder: (BuildContext context, dynamic entry, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: FadeIn(
                child: MapSalesCard(context: context, sale: entry as SaleData)),
          );
        }
        return FadeIn(
            child: MapSalesCard(context: context, sale: entry as SaleData,close:close));
      },
      noItemsFoundBuilder: (BuildContext context) {
        return Text(trans(context, "noting_to_show"));
      },
    );
  }
}
