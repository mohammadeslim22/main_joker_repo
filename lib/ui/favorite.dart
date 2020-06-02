import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:provider/provider.dart';
import 'main/merchant_list.dart';
import 'main/sales_list.dart';
import 'widgets/favoritetab_bar.dart';



class Favorite extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Favorite>
    with SingleTickerProviderStateMixin {
     
  @override
  Widget build(BuildContext context) {
        final MyCounter bolc = Provider.of<MyCounter>(context);

    return Scaffold(
      appBar:  AppBar(
          title: Text(
            trans(context, "fav"),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize:const  Size.fromHeight(50.0), 
            child: FavoritBar(),
          )),
      body: (bolc.favocurrentIndex == 0)
          ?const DiscountsList()
          : ShopList(),
    );
  }
}
