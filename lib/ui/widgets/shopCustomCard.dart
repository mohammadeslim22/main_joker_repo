import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:joker/models/discount.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/util/dio.dart';
import '../../ui/cards/sale_card.dart';
import 'package:joker/models/sales.dart';

class ShopDiscountList extends StatefulWidget {
  const ShopDiscountList(this.movieData);
  final List<Discount> movieData;
  @override
  _DiscountsListState createState() => _DiscountsListState(movieData);
}

class _DiscountsListState extends State<ShopDiscountList> {
  _DiscountsListState(this.movieData);
  final List<Discount> movieData;
  MyCounter bolc;
  List<SaleData> salesData;
  Sales sale;
  Future<List<SaleData>> getsalesData() async {
    await dio
        .get<dynamic>("sales")
        .then((dynamic value) => sale = Sales.fromJson(value));

    return sale.data;
  }

  @override
  void initState() {
    super.initState();
    getsalesData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SaleData>>(
        future: getsalesData(),
        builder: (BuildContext ctx, AsyncSnapshot<List<SaleData>> snapshot) {
          getsalesData().then((List<SaleData> onValue) {
            salesData = onValue;
          });
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: movieData.length,
              addRepaintBoundaries: true,
              itemBuilder: (BuildContext context, int index) {
                return SalesCard(
                    context: context, sale: salesData.elementAt(index));
              },
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ));
          }
        });
  }
}
