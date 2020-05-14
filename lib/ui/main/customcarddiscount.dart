import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/counter.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ui/cards/sale_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/src/response.dart';

class DiscountsList extends StatefulWidget {
  @override
  _DiscountsListState createState() => _DiscountsListState();
}

class _DiscountsListState extends State<DiscountsList> {
  List<SaleData> salesData;
  Sales sale;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MyCounter bolc;
  Future<List<SaleData>> getsalesData() async {
    final Response response = await dio
        .get<dynamic>("sales");

        sale=Sales.fromJson(response.data);
  
    return sale.data;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(
          waterDropColor: Colors.orange,
        ),
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
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: FutureBuilder<List<SaleData>>(
            future: getsalesData(),
            builder:
                (BuildContext ctx, AsyncSnapshot<List<SaleData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data[0].merchant);
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: snapshot.data.length,
                    addRepaintBoundaries: true,
                    itemBuilder: (BuildContext context, int index) {
                      return FadeIn(
                          child: SalesCard(
                              context: context,
                              sale: snapshot.data.elementAt(index)));
                    });
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                ));
              }
            }));
  }
}
