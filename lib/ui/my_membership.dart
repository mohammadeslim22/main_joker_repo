import 'package:animated_card/animated_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import '../models/membership.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class MyMemberShip extends StatefulWidget {
  @override
  MyMemberShipState createState() => MyMemberShipState();
}

class MyMemberShipState extends State<MyMemberShip>
    with SingleTickerProviderStateMixin {
  Memberships memberships;

  Future<List<MembershipData>> getMembershipsData(int pageIndex) async {
    final Response<dynamic> response = await dio.get<dynamic>("usermemberships",
        queryParameters: <String, dynamic>{'page': pageIndex + 1});
    memberships = Memberships.fromJson(response.data);
    return memberships.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "my_membership"), style: styles.appBars),
        centerTitle: true,
      ),
      body: PagewiseListView<dynamic>(
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
            return AnimatedCard(
              direction: AnimatedCardDirection.left,
              initDelay: const Duration(milliseconds: 0),
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
              child: _itemBuilder(context, entry as MembershipData),
            );
          },
          noItemsFoundBuilder: (BuildContext context) {
            return Text(trans(context, "noting_to_show"));
          },
          pageFuture: (int pageIndex) {
            return getMembershipsData(pageIndex);
          }),
    );
  }

  Widget _itemBuilder(BuildContext context, MembershipData memberShip) {
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                          mini: true,
                          heroTag: memberShip.membership.merchant,
                          elevation: 0,
                          backgroundColor: colors.trans,
                          onPressed: () {},
                          child: SvgPicture.asset("assets/images/vip.svg"),
                        ),
                        Text(
                          memberShip.membership.type,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(trans(context, "age_staged"),
                            style: styles.agestaged),
                        const SizedBox(height: 12),
                        Text(memberShip.membership.ageStage,
                            style: styles.underHead),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                          child: const VerticalDivider(
                              color: Colors.grey, thickness: 1),
                          height: 45),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              memberShip.membership.title,
                              style: styles.underHead,
                            ),
                            const SizedBox(height: 10),
                            Text(memberShip.membership.meesage),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: <Widget>[
                            //     Text("${memberShip.startAt}".split(' ')[0],
                            //         style: styles.mysmall),
                            //     Icon(Icons.arrow_forward, color: colors.blue, size: 12),
                            //     Text("${memberShip.endAt}".split(' ')[0],
                            //         style: styles.mysmall)
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /* Flexible(
                  child: CachedNetworkImage(
                    placeholderFadeInDuration:
                        const Duration(milliseconds: 300),
                    imageUrl: "",
                    fit: BoxFit.cover,

                    // imageBuilder:
                    //     (BuildContext context, ImageProvider imageProvider) =>
                    //         Container(
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: DecorationImage(
                    //         image: imageProvider,
                    //         fit: BoxFit.cover,
                    //         colorFilter: const ColorFilter.mode(
                    //             Colors.white, BlendMode.colorBurn)),
                    //   ),
                    // ),
                    placeholder: (BuildContext context, String url) =>
                        const CircularProgressIndicator(),
                    errorWidget:
                        (BuildContext context, String url, dynamic error) =>
                            const Icon(Icons.error),
                  ),
                  //     Image.asset(
                  //   "assets/images/qrcode.png",
                  //   scale: 2,
                  // )
                ) */
              ],
            ),
          ),
        ));
  }
}
