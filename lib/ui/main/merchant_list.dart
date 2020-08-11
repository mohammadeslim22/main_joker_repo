import 'package:flutter/cupertino.dart';
import 'package:joker/models/branches_model.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:flutter/material.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../ui/cards/merchant_card.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:dio/dio.dart';

class ShopList extends StatefulWidget {
  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
 
  Branches branches;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MainProvider bolc;
  Future<List<BranchData>> getBranchesData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("branches",
        queryParameters: <String, dynamic>{'page': pageIndex + 1});
    print(response.data);
    branches = Branches.fromJson(response.data);
    return branches.data;
  }

   PagewiseLoadController<dynamic> _pagewiseController;


@override
  void initState() {
   _pagewiseController=  PagewiseLoadController<dynamic>(
  pageSize: 5,
  pageFuture: (int pageIndex)async {
    return getBranchesData(pageIndex);
  }
);
    super.initState();
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
          onRefresh: () async {
         _pagewiseController.reset();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        
        
         await Future<void>.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          setState(() {});
          _refreshController.loadComplete();
        }
      },
      child: PagewiseListView<dynamic>(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          loadingBuilder: (BuildContext context) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ));
          },
          
          itemBuilder: (BuildContext context, dynamic entry, int index) {
            return FadeIn(child: MerchantCard(branchData: entry as BranchData));
          },
          pageLoadController: _pagewiseController,
          ),
    );
  }
}
