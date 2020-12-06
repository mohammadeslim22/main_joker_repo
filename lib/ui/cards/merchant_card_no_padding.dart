import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/service_locator.dart';
import 'package:rating_bar/rating_bar.dart';

class MapMerchantCard extends StatefulWidget {
  const MapMerchantCard({Key key, this.branchData}) : super(key: key);
  final MapBranch branchData;

  @override
  _MerchantCardState createState() => _MerchantCardState();
}

class _MerchantCardState extends State<MapMerchantCard> {
  MapBranch branchData;

  @override
  void initState() {
    super.initState();
    branchData = widget.branchData;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(0),
              height: MediaQuery.of(context).size.height * .2,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    onError: (dynamic exception, StackTrace stackTrace) {},
                    image: CachedNetworkImageProvider(
                      branchData.merchant.logo,
                    )),
              ),
              child: Stack(children: <Widget>[
                Positioned(
                  left: 8.0,
                  top: 8.0,
                  child: CircleAvatar(
                    backgroundColor: colors.white,
                    radius: 16,
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
                        // TODO(Mohammad): share social
                      },
                      child: Icon(Icons.share, color: colors.white)),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: InkWell(
                      onTap: () {
                        favFunction("App\\Branch", branchData.id);
                      },
                      child: Icon(Icons.favorite_border, color: colors.white)),
                ),
              ])),
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
                      initialRating:
                          double.parse(branchData.rateAverage.toString()),
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
          ),
          RaisedButton(
              color: colors.yellow,
              padding: const EdgeInsets.symmetric(horizontal: 130),
              child: Text(trans(context, 'more_info'), style: styles.moreInfo),
              onPressed: () {
                if (config.loggedin) {
                  Navigator.pushNamed(context, "/MerchantDetails",
                      arguments: <String, dynamic>{
                        "merchantId": branchData.merchant.id,
                        "branchId": branchData.id,
                        "source": "click"
                      });
                } else {
                  getIt<NavigationService>().navigateToNamed('/login', null);
                }
              })
        ],
      ),
    );
  }
}
