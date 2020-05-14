import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/models/shop.dart';
import 'package:joker/providers/counter.dart';
import 'package:flutter/material.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ui/cards/merchant_card.dart';

class ShopList extends StatefulWidget {
  const ShopList(this.movieData);
  final List<Shop> movieData;
  @override
  _ShopListState createState() => _ShopListState(movieData);
}

class _ShopListState extends State<ShopList> {
  _ShopListState(this.movieData);
  final List<Shop> movieData;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MyCounter bolc;
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
        header: const WaterDropMaterialHeader(
          color: Colors.white,
          offset: 00,
        ),
        // WaterDropHeader(waterDropColor: Colors.orange,),
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
        child: FutureBuilder<List<Shop>>(
            // future: shops,
            builder: (BuildContext ctx, AsyncSnapshot<List<Shop>> snapshot) {
          //   shops.then((List<Shop> onValue){
          //  //   templList= onValue;
          //   });
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: movieData.length,
              addRepaintBoundaries: true,
              itemBuilder: (BuildContext context, int index) {
                return FadeIn(
                    child: MerchantCard(
                        context: context, shop: movieData.elementAt(index)));
              },
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ));
          }
        }));
  }
}
