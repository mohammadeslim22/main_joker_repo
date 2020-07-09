import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:provider/provider.dart';
import 'main/favorits_merchant_list.dart';
import 'main/favorits_sales_list.dart';
import 'widgets/favoritetab_bar.dart';
import '../constants/colors.dart';

class Favorite extends StatefulWidget {
  @override
  _MyFavState createState() => _MyFavState();
}

class _MyFavState extends State<Favorite> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final MinProvider bolc = Provider.of<MinProvider>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text(
              trans(context, "fav"),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: FavoritBar(),
            )),
        body: Container(
          color: colors.grey,
          child: (bolc.favocurrentIndex == 0)
              ? const FavoritMerchantsList()
              : const FavoritDiscountsList(),
        ));
  }
}
