import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/merchant.dart';
import 'package:joker/util/dio.dart';
import 'package:like_button/like_button.dart';
import 'package:rating_bar/rating_bar.dart';
import 'main/merchant_sales_list.dart';

class ShopDetails extends StatefulWidget {
  const ShopDetails({Key key, this.likecount, this.lovecount, this.merchantId})
      : super(key: key);

  final int likecount;
  final int lovecount;
  final int merchantId;

  @override
  ShopDetailsPage createState() => ShopDetailsPage();
}

class ShopDetailsPage extends State<ShopDetails> with TickerProviderStateMixin {
  Merchant merchant;

  Future<Merchant> getMerchantData(int id) async {
    final dynamic response = await dio.get<dynamic>("merchants/$id");
    merchant = Merchant.fromJson(response.data);
    return merchant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(trans(context, "shop_details")), centerTitle: true),
      body: FutureBuilder<Merchant>(
        future: getMerchantData(widget.merchantId),
        builder: (BuildContext ctx, AsyncSnapshot<Merchant> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Page(
                likecount: widget.likecount,
                lovecount: widget.lovecount,
                merchant: merchant);
          } else {
            return const Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent));
          }
        },
      ),
    );
  }
}

class Page extends StatefulWidget {
  const Page({Key key, this.likecount, this.lovecount, this.merchant})
      : super(key: key);
  final int likecount;
  final int lovecount;
  final Merchant merchant;
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  TabController _tabController;
  int index = 2;
  double ratingStar = 0;
  Color tabBackgroundColor = colors.trans;
  Merchant merchant;
  int likecount;
  int lovecount;
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  @override
  void initState() {
    super.initState();
    merchant = widget.merchant;
    _tabController =
        TabController(vsync: this, length: merchant.mydata.branches.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
      } else if (_tabController.index != _tabController.previousIndex) {}
    });

    likecount = widget.likecount;
    lovecount = widget.lovecount;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                      image: NetworkImage(merchant.mydata.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(merchant.mydata.name, style: styles.underHead),
                        const SizedBox(height: 6),
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
                                color: !isLiked ? Colors.grey : Colors.blue,
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
                          countBuilder: (int c, bool b, String count) {
                            return Text(
                              count,
                              style: const TextStyle(color: Colors.black),
                            );
                          },
                          likeCount: lovecount,
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
                              countBuilder: (int c, bool b, String count) {
                                return Text(
                                  count,
                                  style: const TextStyle(color: Colors.black),
                                );
                              },
                              likeCount: lovecount,
                              countPostion: CountPostion.bottom,
                              circleColor: CircleColor(
                                  start: Colors.blue, end: Colors.purple),
                              onTap: (bool loved) {
                                return onLikeButtonTapped(loved);
                              },
                              likeCountPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                            ),
                            const SizedBox(height: 6)
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
                  tabs: merchant.mydata.branches.map((Branches tab) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          color: _tabController.index != tab.id
                              ? tabBackgroundColor
                              : colors.orange,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        child: Text(
                          tab.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _tabController.index != tab.id
                                ? Colors.black
                                : colors.orange,
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
                  children: merchant.mydata.branches.map((Branches tab) {
                    return Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Image.asset(
                            "assets/images/addreess_icon.png",
                            scale: 3.5,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 5),
                          Text(tab.address)
                        ]),
                        const SizedBox(height: 10),
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
                                      Text(trans(context, "rate_shop"),
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
                  "   ( ${merchant.mydata.branches.length} )"),
              InkWell(
                child: Text(trans(context, "show_all")),
                onTap: () {},
              ),
            ],
          ),
        ),
        Container(child: MerchantSalesList())
      ],
    );
  }
}
