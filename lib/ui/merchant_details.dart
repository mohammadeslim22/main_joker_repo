import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/merchant.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/functions.dart';
import 'package:like_button/like_button.dart';
import 'package:rating_bar/rating_bar.dart';
import 'main/merchant_sales_list.dart';
import '../util/service_locator.dart';
import 'package:joker/providers/merchantsProvider.dart';

class ShopDetails extends StatelessWidget {
  const ShopDetails({Key key, this.merchantId, this.branchId, this.source})
      : super(key: key);
  final int merchantId;
  final int branchId;
  final String source;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.white,
      child: FutureBuilder<void>(
        future:
            getIt<MerchantProvider>().getMerchantData(merchantId, source, 0),
        builder: (BuildContext ctx, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Page(
                merchant: getIt<MerchantProvider>().merchant,
                branchId: branchId);
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
  const Page({Key key, this.merchant, this.branchId}) : super(key: key);
  final Merchant merchant;
  final int branchId;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  TabController _tabController;
  int index;
  double ratingStar;
  Color tabBackgroundColor = colors.ggrey;
  Merchant merchant;
  int likecount;
  int lovecount;
  int salesNo;
  bool isliked;
  bool isloved;
  @override
  void initState() {
    super.initState();
    merchant = widget.merchant;
    salesNo = merchant.mydata.salesCount;
    index = merchant.mydata.branches[0].id;
    _tabController =
        TabController(vsync: this, length: merchant.mydata.branches.length);
    _tabController.addListener(() {
      setState(() {
        index = merchant.mydata.branches[_tabController.index].id;
      });

      if (_tabController.indexIsChanging) {
      } else if (_tabController.index != _tabController.previousIndex) {}
    });

    likecount = merchant.mydata.likesCount;
    isliked = merchant.mydata.isliked != 0;
    ratingStar =
        merchant.mydata.branches.firstWhere((MerchantBranches element) {
      return element.id == widget.branchId;
    }).rateAverage;
    isloved = merchant.mydata.isfavorite != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(trans(context, "shop_details"), style: styles.appBars),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<dynamic>(
                elevation: 0,
                isDense: false,
                icon: const Icon(Icons.more_vert),
                items: <dynamic>[trans(context, "join")].map((dynamic value) {
                  return DropdownMenuItem<dynamic>(
                    value: value,
                    onTap: () {},
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (dynamic value) {
                  Navigator.pushNamed(context, "/MemberShipsForMerchant",
                      arguments: <String, dynamic>{
                        "merchantId":
                            getIt<MerchantProvider>().merchant.mydata.id
                      });
                },
              ),
            )
          ]),
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
                                child: Image.asset("assets/images/like.png",
                                    width: 10, height: 10),
                              );
                            },
                            isLiked: merchant.mydata.isliked != 0,
                            likeCountPadding:
                                const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            countBuilder: (int c, bool b, String count) {
                              return Text(
                                count,
                                style: const TextStyle(color: Colors.black),
                              );
                            },
                            likeCount: likecount,
                            countPostion: CountPostion.bottom,
                            circleColor: const CircleColor(
                                start: Colors.white, end: Colors.purple),
                            onTap: (bool loved) async {
                              likeFunction("App\\Merchant", merchant.mydata.id);
                              isliked = !isliked;
                              return isliked;
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
                                isLiked: merchant.mydata.isfavorite != 0,
                                countPostion: CountPostion.bottom,
                                circleColor: CircleColor(
                                    start: colors.blue, end: Colors.purple),
                                onTap: (bool loved) async {
                                  favFunction("App\\Branch", widget.branchId);
                                  isloved = !isloved;
                                  return isloved;
                                },
                                likeCountPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                              ),
                              const SizedBox(height: 20)
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
                  child: Divider(color: Colors.grey, thickness: 1),
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
                        index = merchant.mydata.branches[i].id;
                      });
                    },
                    controller: _tabController,
                    tabs: merchant.mydata.branches.map((MerchantBranches tab) {
                      print("tabs ids: ${tab.id}");
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            color: index != tab.id
                                ? tabBackgroundColor
                                : colors.jokerBlue,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                          child: Text(
                            tab.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  index == tab.id ? Colors.white : colors.white,
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
                    children:
                        merchant.mydata.branches.map((MerchantBranches tab) {
                      return Column(
                        children: <Widget>[
                          Row(children: <Widget>[
                            Image.asset("assets/images/addreess_icon.png",
                                scale: 3.5, fit: BoxFit.cover),
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
                                child: Text(trans(context, "send_complaint"),
                                    style: styles.mystyle),
                              ),
                              Column(
                                children: <Widget>[
                                  RatingBar(
                                    onRatingChanged: (double rating) async {
                                      await dio.post<dynamic>("rates",
                                          data: <String, dynamic>{
                                            'rateable_type': "App\\Branch",
                                            'rateable_id': index,
                                            'rate_value': rating
                                          });
                                    },
                                    initialRating: ratingStar,
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    halfFilledIcon: Icons.star_half,
                                    isHalfAllowed: true,
                                    filledColor: Colors.amberAccent,
                                    emptyColor: Colors.grey,
                                    halfFilledColor: Colors.blue[300],
                                    size: 30,
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: <Widget>[
                                        Text(trans(context, "rate_shop"),
                                            style: styles.mystyle),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: colors.blue,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(trans(context, "shop_offers") + "( $salesNo )"),
                InkWell(
                  child: Text(trans(context, "show_all")),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
              child: MerchantSalesList(merchantId: widget.merchant.mydata.id))
        ],
      ),
    );
  }
}
