import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import '../models/branch.dart';
import '../models/discount.dart';
import '../models/shop.dart';
import 'package:like_button/like_button.dart';
import 'package:rating_bar/rating_bar.dart';

import 'widgets/shopCustomCard.dart';

class ShopDetails extends StatefulWidget {
  const ShopDetails({Key key, this.shop, this.likecount, this.lovecount})
      : super(key: key);
  final Shop shop;
  final int likecount;
  final int lovecount;
  @override
  ShopDetailsPage createState() => ShopDetailsPage();
}

class ShopDetailsPage extends State<ShopDetails> with TickerProviderStateMixin {
 
  double ratingStar = 0;
  String text2 = "5";
  String text = "4";
  Color tabBackgroundColor = colors.trans;
  List<Branch> branches = Branch.branchData;
  TabController _tabController;
  Color floatingbuttonCo = Colors.grey;
  int index = 2;
  Color containercolor = Colors.grey;

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: branches.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
      } else if (_tabController.index != _tabController.previousIndex) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          trans(context, "shop_details"),
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      image: DecorationImage(
                        image: AssetImage(
                          widget.shop.image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            trans(context, 'shop_name'),
                            style: styles.underHead,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(trans(context, 'city'), style: styles.mylight),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          LikeButton(
                            size: 26,
                            likeBuilder: (bool isLiked) {
                              return Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: !isLiked
                                      ? Colors.grey
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: Image.asset(
                                  "assets/images/like.png",
                                  width: 10,
                                  height: 10,
                                ),
                              );
                            },
                            likeCountPadding:
                                const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            countBuilder: (int c, bool b, String i) {
                              return Text(
                                i,
                                style: const TextStyle(color: Colors.black),
                              );
                            },
                            likeCount: widget.lovecount,
                            countPostion: CountPostion.bottom,
                            circleColor: CircleColor(
                                start: Colors.white, end: Colors.purple),
                            onTap: (bool loved) {
                              return onLikeButtonTapped(loved);
                            },
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LikeButton(
                                size: 31,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                countBuilder: (int c, bool b, String i) {
                                  return Text(
                                    i,
                                    style:const TextStyle(color: Colors.black),
                                  );
                                },
                                likeCount: widget.lovecount,
                                countPostion: CountPostion.bottom,
                                circleColor: CircleColor(
                                    start: Colors.blue, end: Colors.purple),
                                onTap: (bool loved) {
                                  return onLikeButtonTapped(loved);
                                },
                                likeCountPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                              ),
                              const SizedBox(
                                height: 6,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    trans(context, "shop_branches"),
                    style: styles.mystyle,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.grey[300],
                child: TabBar(
                    indicatorColor: colors.trans,
                    isScrollable: true,
                    onTap: (int i) {
                      setState(() {
                        index = i;
                      });
                    },
                    controller: _tabController,
                    tabs: branches.map((Branch tab) {
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            color: _tabController.index != tab.id
                                ? tabBackgroundColor
                                : Colors.orange[100],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                          child: Text(
                            tab.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _tabController.index != tab.id
                                  ? Colors.black
                                  : Colors.orange,
                            ),
                          ));
                    }).toList()),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                width: MediaQuery.of(context).size.width,
                height: 96,
                child: TabBarView(
                    controller: _tabController,
                    children: branches.map((Branch tab) {
                      return Column(
                        children: <Widget>[
                          Row(children: <Widget>[
                            Image.asset(
                              "assets/images/addreess_icon.png",
                              scale: 3.5,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(tab.address)
                          ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RaisedButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                ),
                                onPressed: () {},
                                color: Colors.grey[300],
                                textColor: Colors.black,
                                child: Text(
                                    trans(
                                      context,
                                      "send_complaint",
                                    ),
                                    style: styles.mystyle),
                              ),
                              Column(
                                children: <Widget>[
                                  RatingBar(
                                    onRatingChanged: (double rating) =>
                                        setState(() => ratingStar = rating),
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    halfFilledIcon: Icons.star_half,
                                    isHalfAllowed: true,
                                    filledColor: Colors.amberAccent,
                                    emptyColor: Colors.grey,
                                    halfFilledColor: Colors.orange[300],
                                    size: 20,
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                            trans(
                                              context,
                                              "rate_shop",
                                            ),
                                            style: styles.mystyle),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    }).toList()),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(trans(context, "shop_offers") +
                    "   ( ${branches.length} )"),
                InkWell(
                  child: Text(
                    trans(context, "show_all"),
                  ),
                  onTap: () {
                    print("value of your text");
                  },
                ),
              ],
            ),
          ),
          Container(child: ShopDiscountList(Discount.movieData))
        ],
      ),
    );
  }
}
