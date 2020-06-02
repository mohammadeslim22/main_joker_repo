import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/branches_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:joker/models/merchant.dart';

class MerchantCard extends StatefulWidget {
  const MerchantCard({Key key,  this.branchData}) : super(key: key);
  final BranchData branchData;

  @override
  _MerchantCardState createState() => _MerchantCardState();
}

class _MerchantCardState extends State<MerchantCard> {
  bool isliked = false;
  BranchData branchData;
    Merchant merchant;

   @override
  void initState() {
    super.initState();
    branchData = widget.branchData;
  }

  @override
  Widget build(BuildContext context) {
 const String text = "4 ";
    const String text2 = "5";
    return Card(
      margin: const EdgeInsets.fromLTRB(24,0,24,8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () async {
           Navigator.pushNamed(context, "/MerchantDetails",
           arguments:<String, dynamic>{"merchantId":branchData.merchant.id,"lovecount":50,"likecount":50});
        },
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .2,
              decoration:  BoxDecoration(
                borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                image: DecorationImage(
                       image: CachedNetworkImageProvider(
                  branchData.merchant.logo,
                ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(children: <Widget>[
                Positioned(
                  left: 8.0,
                  top: 8.0,
                  child: CircleAvatar(
                          backgroundColor: colors.white,
                          radius: 12,
                          child: SvgPicture.asset(
                            'assets/images/loveicon.svg',
                          ),
                        ),
                ),
              ]),
            ),
            Container(
          
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${trans(context, 'shop_name')}',
                    softWrap: true,
                    style: styles.underHead,
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
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    color: Colors.grey[300]),
                                alignment: Alignment.center,
                                child: Text(
                                  text,
                                  softWrap: true,
                                  style: styles.mystyle,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Text(
                              trans(context, 'current_sales'),
                              style: styles.mylight,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 7),
                            Text(
                              text2,
                              style: styles.mystyle,
                            )
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
