import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/ui/cards/sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/util/service_locator.dart';

class MerchantSalesList extends StatelessWidget {
  const MerchantSalesList({Key key, this.merchantId}) : super(key: key);

  final int merchantId;
  @override
  Widget build(BuildContext context) {
    return PagewiseListView<dynamic>(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        loadingBuilder: (BuildContext context) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
          ));
        },
        pageSize: 15,
        
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, dynamic entry, int index) {
          return FadeIn(child: SalesCard(sale: entry as SaleData));
        },
        pageFuture: (int pageIndex) {
          return getIt<SalesProvider>()
              .getMerchantSalesData(pageIndex, merchantId);
        });
  }
}
