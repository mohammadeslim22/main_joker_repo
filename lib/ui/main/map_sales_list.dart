import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:flutter/material.dart';
import 'package:joker/util/service_locator.dart';
import '../../ui/cards/map_sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/providers/globalVars.dart';

class MapSalesList extends StatefulWidget {
  const MapSalesList({Key key, this.sc}) : super(key: key);
  final ScrollController sc;
  // final FilterData filterData;
  @override
  _MapSalesListState createState() => _MapSalesListState();
}

class _MapSalesListState extends State<MapSalesList> {
  MainProvider bolc;

  @override
  void initState() {
    super.initState();
    getIt<SalesProvider>().pagewiseSalesController =
        PagewiseLoadController<dynamic>(
            pageSize: 3,
            pageFuture: (int pageIndex) async {
              return (getIt<GlobalVars>().filterData != null)
                  ? getIt<SalesProvider>().getSalesDataFilterd(
                      pageIndex, getIt<GlobalVars>().filterData)
                  : getIt<SalesProvider>().getSalesData(pageIndex);
            });
  }

  @override
  Widget build(BuildContext context) {
    return PagewiseListView<dynamic>(
      physics: const ScrollPhysics(),
      controller: widget.sc,
      shrinkWrap: true,
      loadingBuilder: (BuildContext context) {
        return const Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
        ));
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
            child: MapSalesCard(context: context, sale: entry as SaleData));
      },
      noItemsFoundBuilder: (BuildContext context) {
        return Text(trans(context, "noting_to_show"));
      },
    );
  }
}
