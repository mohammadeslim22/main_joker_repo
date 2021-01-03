import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joker/models/branches_model.dart';
import 'package:joker/models/sales.dart';

class FaveCard extends StatelessWidget {
  const FaveCard({Key key, this.sale, this.branch}) : super(key: key);
  final SaleData sale;
  final BranchData branch;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CachedNetworkImage(imageUrl: ""),
        Expanded(
            child: Column(
          children: [Text(""), Text("")],
        )),
        Column(children: [])
      ],
    );
  }
}
