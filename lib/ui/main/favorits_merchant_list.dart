import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ui/cards/merchant_card.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:dio/dio.dart';
import 'package:joker/models/branches_model.dart';

class FavoritMerchantsList extends StatefulWidget {
  const FavoritMerchantsList({Key key}) : super(key: key);

  @override
  _MerchantsListState createState() => _MerchantsListState();
}

class _MerchantsListState extends State<FavoritMerchantsList> {
  List<BranchData> branchesData;
  Branches branches;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MyCounter bolc;

  Future<List<BranchData>> getFavoritData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("favorites",
        queryParameters: <String, dynamic>{
          'page': pageIndex + 1,
          'model': "App\\Branch"
        });
    branches = Branches.fromJson(response.data);
    return branches.data;
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: false,
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
      child: PagewiseListView<dynamic>(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          loadingBuilder: (BuildContext context) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ));
          },
          pageSize: 10,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, dynamic entry, int index) {
            return FadeIn(child: MerchantCard(branchData: entry as BranchData));
          },
          noItemsFoundBuilder: (BuildContext context) {
            return Text(trans(context, "noting_to_show_rn"));
          },
          pageFuture: (int pageIndex) {
            return getFavoritData(pageIndex);
          }),
    );
  }
}
