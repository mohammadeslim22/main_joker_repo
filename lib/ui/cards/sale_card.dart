import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';

class SalesCard extends StatefulWidget {
  const SalesCard({Key key, this.context, this.sale}) : super(key: key);
  final BuildContext context;
  final SaleData sale;

  @override
  _SalesCardState createState() => _SalesCardState();
}

Color saleStatus;

class _SalesCardState extends State<SalesCard> {
  bool isliked = false;
  SaleData saledata;
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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/SaleDetails",
              arguments: <String, dynamic>{
                "merchant_id": saledata.merchant.id,
                "sale_id": saledata.id
              });
        },
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                  saledata.cropedImage,
                )),
              ),
              child: saledata.isfavorite != 0
                  ? Stack(children: <Widget>[
                      Positioned(
                        left: 8.0,
                        top: 8.0,
                        child: CircleAvatar(
                          backgroundColor: colors.white,
                          radius: 12,
                          child: SvgPicture.asset('assets/images/loveicon.svg'),
                        ),
                      ),
                    ])
                  : Container(),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
              child: Column(
                children: <Widget>[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child:
                              Text(saledata.name, style: styles.underHeadblack),
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(saledata.status, style: styles.mylight),
                                const SizedBox(width: 5),
                                CircleAvatar(
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
                            widget.sale.price ?? "35",
                            style: styles.redstyleForSaleScreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.sale.oldPrice,
                            style: TextStyle(
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
                            Text(trans(context, 'branch'),
                                style: styles.mylight),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                color: Colors.grey[200],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                trans(context, 'branches_with_offer'),
                                style: styles.mystyle,
                              ),
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
            )
          ],
        ),
      ),
    );
  }
}
