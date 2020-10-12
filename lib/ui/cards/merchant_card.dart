import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/branches_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rating_bar/rating_bar.dart';

class MerchantCard extends StatefulWidget {
  const MerchantCard({Key key, this.branchData}) : super(key: key);
  final BranchData branchData;

  @override
  _MerchantCardState createState() => _MerchantCardState();
}

class _MerchantCardState extends State<MerchantCard> {
  BranchData branchData;

  @override
  void initState() {
    super.initState();
    branchData = widget.branchData;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () async {
          Navigator.pushNamed(context, "/MerchantDetails",
              arguments: <String, dynamic>{
                "merchantId": branchData.merchant.id,
                "branchId": branchData.id,
                "source": "click"
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
                    fit: BoxFit.cover,
                    onError: (dynamic exception, StackTrace stackTrace) {},
                    image: CachedNetworkImageProvider(
                      branchData.merchant.logo,
                    )),
              ),
              child: branchData.isfavorite != 0
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
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(branchData.merchant.name,
                            softWrap: true, style: styles.underHead),
                      ),
                      RatingBar(
                        initialRating: double.parse(
                            branchData.merchant.rateAverage.toString()),
                        filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        halfFilledIcon: Icons.star_half,
                        isHalfAllowed: true,
                        filledColor: Colors.amberAccent,
                        emptyColor: Colors.grey,
                        halfFilledColor: Colors.blue[300],
                        size: 10,
                        onRatingChanged: (double rating) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(trans(context, 'city'), style: styles.mylight),
                          Row(
                            children: <Widget>[
                              Text(trans(context, 'branches_number'),
                                  style: styles.mystyle),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    color: Colors.grey[300]),
                                alignment: Alignment.center,
                                child: Text(branchData.id.toString(),
                                    softWrap: true, style: styles.mystyle),
                              )
                            ],
                          ),
                        ],
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Text(trans(context, 'current_sales'),
                                style: styles.mylight,
                                textAlign: TextAlign.center),
                            const SizedBox(height: 4),
                            Text(branchData.salesCount.toString(),
                                style: styles.mystyle)
                          ],
                        ),
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
