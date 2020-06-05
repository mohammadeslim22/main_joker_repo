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

class _SalesCardState extends State<SalesCard> {
  bool isliked = false;
  SaleData saledata;
  @override
  void initState() {
    super.initState();
    saledata = widget.sale;
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
           arguments:<String, dynamic>{"merchant_id":saledata.merchant.id});
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
              child: isliked
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(saledata.name, style: styles.underHead),
                        ),
                        Row(
                          children: <Widget>[
                            Text(saledata.status, style: styles.mylight),
                            const SizedBox(width: 5),
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 6,
                            )
                          ],
                        )
                      ]),
                  const SizedBox(height: 8),
                  Text(trans(context, 'discount_type'), style: styles.mylight),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/images/merchants.svg",
                        color: colors.black,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                          child: Text(saledata.merchant.name,
                              softWrap: true, style: styles.mystyle)),
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
                              Text(
                                saledata.startAt,
                                style: styles.mystyle,
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const SizedBox(width: 36),
                          Column(
                            children: <Widget>[
                              Text(
                                trans(context, 'end_date'),
                                style: styles.mysmalllight,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                saledata.endAt,
                                style: styles.mystyle,
                              )
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
