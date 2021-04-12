import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/util/size_config.dart';
import 'package:provider/provider.dart';
import 'main/favorits_merchant_list.dart';
import 'main/favorits_sales_list.dart';
import 'widgets/favoritetab_bar.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

class Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text(trans(context, "fav"), style: styles.appBars),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical * 6),
              child: FavoritBar(),
            )),
        body: Container(
          color: colors.white,
          child: (bolc.favocurrentIndex == 0)
              ? FavoritMerchantsList()
              : FavoritDiscountsList(),
        )
        );
  }
}
