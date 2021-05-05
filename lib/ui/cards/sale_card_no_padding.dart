import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/service_locator.dart';

class SalesCardNoPadding extends StatefulWidget {
  const SalesCardNoPadding({Key key, this.context, this.sale})
      : super(key: key);
  final BuildContext context;
  final SaleData sale;

  @override
  _SalesCardState createState() => _SalesCardState();
}

Color saleStatus;

class _SalesCardState extends State<SalesCardNoPadding> {
  bool isliked = false;
  SaleData saledata;
  String branches;
  @override
  void initState() {
    super.initState();
    saledata = widget.sale;
    if (saledata.status == "active") {
      saleStatus = Colors.green;
    } else if (saledata.status == "coming") {
      saleStatus = Colors.yellow;
    } else {
      saleStatus = Colors.red;
    }
    // print(saledata.branches.length);

    // if (saledata.branches.isNotEmpty) {
    //   saledata.branches.forEach((int element) {
    //     branches += element.toString() + " ";
    //   });
    // } else {
    //   branches = "0";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    saledata.cropedImage,
                  )),
            ),
            child: Stack(children: <Widget>[
              Positioned(
                left: 8.0,
                top: 8.0,
                child: CircleAvatar(
                  backgroundColor: colors.white,
                  radius: 12,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Positioned(
                right: 36.0,
                top: 8.0,
                child: InkWell(
                    onTap: () {
                      // TODO(Mohammad): shre social
                    },
                    child: Icon(Icons.share, color: colors.white)),
              ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: InkWell(
                    onTap: () {
                      favFunction("App\\Sale", saledata.id);
                    },
                    child: Icon(Icons.favorite_border, color: colors.white)),
              ),
            ])),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
          child: Column(
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(saledata.name, style: styles.underHeadblack),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(saledata.status, style: styles.mylight),
                            const SizedBox(width: 5),
                            const CircleAvatar(
                                backgroundColor: Colors.green, radius: 6)
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    )
                  ]),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/images/merchants.svg",
                            color: colors.black),
                        const SizedBox(width: 8),
                        Flexible(
                            child: Text(saledata.merchant.name,
                                softWrap: true, style: styles.mystyle)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.sale.price ?? "",
                        style: styles.redstyleForSaleScreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.sale.oldPrice,
                        style: const TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Text(trans(context, 'branch'), style: styles.mylight),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            color: Colors.grey[200],
                          ),
                          alignment: Alignment.center,
                          child: Text(saledata.branches.length.toString()),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            trans(context, 'starting_date'),
                            style: styles.mysmalllight,
                          ),
                          const SizedBox(height: 7),
                          Text(saledata.startAt, style: styles.mystyle)
                        ],
                      ),
                      const SizedBox(width: 41),
                      Column(
                        children: <Widget>[
                          Text(
                            trans(context, 'end_date'),
                            style: styles.mysmalllight,
                          ),
                          const SizedBox(height: 7),
                          Text(saledata.endAt, style: styles.mystyle)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: colors.yellow,
              padding: const EdgeInsets.symmetric(horizontal: 130),
            ),
            child: Text(trans(context, 'more_info'), style: styles.moreInfo),
            onPressed: () {
              // if (config.loggedin) {
            if(getIt<Auth>().isAuthintecated){
                final MapBranch m = MapBranch(
                    merchant: Merchant(
                        id: saledata.merchant.id,
                        logo: saledata.merchant.logo,
                        name: saledata.merchant.name,
                        ratesAverage:double.parse(saledata.merchant.ratesAverage.toString()),
                        salesCount: saledata.merchant.salesCount));
                getIt<HOMEMAProvider>().setinFocusBranch(m);
                Navigator.pushNamed(context, "/SaleLoader",
                    arguments: <String, dynamic>{
                      "mapBranch": m,
                      "sale": saledata
                    });
              } else {
                getIt<NavigationService>().navigateTo('/login', null);
              }
            })
      ],
    );
  }
}
