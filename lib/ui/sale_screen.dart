import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/util/size_config.dart';
import '../constants/styles.dart';
import '../models/merchant.dart';
import '../util/dio.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../localization/trans.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/colors.dart';
import '../util/functions.dart';
import '../models/sales.dart';
import '../models/simplesales.dart';
import 'package:after_layout/after_layout.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class Loader extends StatelessWidget {
  const Loader({this.merchentid, this.saleData});
  final int merchentid;
  final SaleData saleData;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.white,
      child: FutureBuilder<void>(
          future:
              getIt<MerchantProvider>().getMerchantData(merchentid, "click", 1),
          builder: (BuildContext ctx, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SaleDetailPage(
                saleData: saleData,
                merchant: getIt<MerchantProvider>().merchant,
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent));
            }
          }),
    );
  }
}

class SaleDetailPage extends StatefulWidget {
  const SaleDetailPage({Key key, this.saleData, this.merchant})
      : super(key: key);

  final Merchant merchant;
  final SaleData saleData;

  @override
  ShopDetailsPage createState() => ShopDetailsPage();
}

class ShopDetailsPage extends State<SaleDetailPage>
    with AfterLayoutMixin<SaleDetailPage>, TickerProviderStateMixin {
  Merchant merchant;
  SaleData sale;
  double clientRatingStar = 0;
  bool hasMemberShip = false;

  PersistentBottomSheetController<dynamic> _errorController;

  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController<dynamic> bottomSheetController;
  Color tabBackgroundColor = colors.trans;
  TextEditingController controller = TextEditingController();
  int index = 0;
  String mytext;
  double extededPlus = 50;
  bool isliked;
  bool isloved;
  bool isbottomSheetOpened;
  int pageIndexx;
  final GlobalKey<BottomWidgetForSliverState> key =
      GlobalKey<BottomWidgetForSliverState>();
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    getIt<SalesProvider>().getSale(widget.saleData.id);
    sale = widget.saleData;
    merchant = widget.merchant;
    controller.addListener(() {
      setState(() {
        mytext = controller.text;
      });
    });
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);

    mytext = sale.details;
    index = 0;
    isliked = sale.isliked != 0;
    isloved = sale.isfavorite != 0;
    print("is fav ${sale.isfavorite}");
    isbottomSheetOpened = false;
    pageIndexx = 1;
    index += merchant.mydata.branches[0].id;
  }

  void getHeight() {
    final State state = key.currentState;
    print("current state ${key.currentState}");
    final RenderBox box = state.context.findRenderObject() as RenderBox;
    setState(() {
      extededPlus = box.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      key: scaffoldkey,
      body: NestedScrollView(
          physics: const ScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                expandedHeight: SizeConfig.screenHeight * .473 + extededPlus,
                elevation: 0,
                backgroundColor: Colors.transparent,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: InkWell(
                    onTap: () {
                      if (isbottomSheetOpened)
                        Future<dynamic>.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            CurasolSlider(sale: sale, myindex: index),
                            Positioned(
                              left: 6,
                              top: 220,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  LikeButton(
                                    circleSize: 50,
                                    size: 31,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    countPostion: CountPostion.bottom,
                                    circleColor: const CircleColor(
                                        start: Colors.blue, end: Colors.purple),
                                    isLiked: isloved,
                                    onTap: (bool loved) async {
                                      print(loved);
                                      favFunction("App\\Sale", sale.id);
                                      if (!loved) {
                                        getIt<SalesProvider>()
                                            .setFavSale(sale.id);
                                      } else {
                                        getIt<SalesProvider>()
                                            .setunFavSale(sale.id);
                                      }
                                      isloved = !isloved;
                                      return isloved;
                                    },
                                    likeCountPadding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                  ),
                                  LikeButton(
                                    circleSize: 50,
                                    size: 26,
                                    likeBuilder: (bool isLiked) {
                                      return Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: !isLiked
                                              ? Colors.black.withOpacity(.5)
                                              : Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                        ),
                                        child: Image.asset(
                                            "assets/images/like.png",
                                            width: 10,
                                            height: 10),
                                      );
                                    },
                                    isLiked: isliked,
                                    likeCountPadding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    countBuilder:
                                        (int c, bool b, String count) {
                                      return Text(
                                        count,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      );
                                    },
                                    likeCount: sale.id,
                                    countPostion: CountPostion.bottom,
                                    circleColor: const CircleColor(
                                        start: Colors.white,
                                        end: Colors.purple),
                                    onTap: (bool loved) async {
                                      likeFunction("App\\Sale", sale.id);
                                      if (!loved) {
                                        getIt<SalesProvider>()
                                            .setLikeSale(sale.id);
                                      } else {
                                        getIt<SalesProvider>()
                                            .setunLikeSale(sale.id);
                                      }
                                      isliked = !isliked;
                                      return isliked;
                                    },
                                  ),
                                  InkWell(
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(Icons.star_border),
                                      ),
                                      onTap: () {
                                        showDialog<dynamic>(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return RatingDialog(
                                                icon: Container(
                                                  height: 100,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          merchant.mydata.logo),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                title: "Please Rate me",
                                                description:
                                                    "Yor feedback Give us Motivation",
                                                submitButton: "SUBMIT",
                                                alternativeButton:
                                                    "Contact us instead?",
                                                positiveComment:
                                                    "We are so happy to hear :)",
                                                negativeComment:
                                                    "We're sad to hear :(",
                                                accentColor: colors.blue,
                                                onSubmitPressed:
                                                    (int rating) async {
                                                  await dio.post<dynamic>(
                                                      "rates",
                                                      data: <String, dynamic>{
                                                        'rateable_type':
                                                            "App\\Sale",
                                                        'rateable_id': sale.id,
                                                        'rate_value': rating
                                                      });
                                                },
                                                onAlternativePressed: () {},
                                              );
                                            });
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        BottomWidgetForSliver(
                          key: key,
                          bottomSheetController: bottomSheetController,
                          mytext: mytext,
                          scaffoldkey: scaffoldkey,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ];
          },
          body: Container(
            color: colors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("merchant_name", style: styles.mysmall),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/images/merchants.svg",
                                  color: colors.black,
                                ),
                                const SizedBox(width: 12),
                                Text(merchant.mydata.name,
                                    style: styles.underHead),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(trans(context, "client_rating"),
                                style: styles.mysmall),
                            const SizedBox(height: 12),
                            RatingBar(
                              onRatingChanged: (double rating) async {
                                print(
                                    "${merchant.mydata.id}   ${merchant.mydata.ratesAverage}");
                                await dio.post<dynamic>("rates",
                                    data: <String, dynamic>{
                                      'rateable_type': "App\\Merchant",
                                      'rateable_id': merchant.mydata.id,
                                      'rate_value': rating
                                    });
                              },
                              filledIcon: Icons.star,
                              initialRating: double.parse(
                                  merchant.mydata.ratesAverage.toString()),
                              emptyIcon: Icons.star_border,
                              halfFilledIcon: Icons.star_half,
                              isHalfAllowed: true,
                              filledColor: Colors.amberAccent,
                              emptyColor: Colors.grey,
                              halfFilledColor: Colors.blue[300],
                              size: 26,
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(trans(context, "rate_shop"),
                                      style: styles.myredstyle),
                                  const SizedBox(width: 12),
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
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 12),
                    Container(height: 30, width: 3, color: colors.blue),
                    const SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text(
                          trans(context, "sale_history"),
                          style: styles.underHeadblack,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Container(
                      height: 3,
                      color: Colors.grey,
                    ))
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/from_to_shape.svg",
                      color: Colors.transparent.withOpacity(.15),
                    ),
                    Positioned(
                      top: 10,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 7),
                          Column(
                            children: <Widget>[
                              Text(trans(context, "from")),
                              const SizedBox(height: 7),
                              Text(
                                sale.startAt,
                                style: styles.mystyle,
                              )
                            ],
                          ),
                          const SizedBox(width: 96),
                          Column(
                            children: <Widget>[
                              Text(trans(context, "to")),
                              const SizedBox(height: 7),
                              Text(sale.endAt, style: styles.mystyle)
                            ],
                          ),
                          const SizedBox(width: 7),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      bottom: 10,
                      child: isRTL
                          ? SvgPicture.asset(
                              "assets/images/arrow_andclipped_line.svg",
                            )
                          : SvgPicture.asset(
                              "assets/images/arrow_andclipped_line2.svg",
                            ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 12),
                    const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        trans(context, "sale_is_available_in_branches"),
                        style: styles.underHeadblack,
                      ),
                    ),
                    const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1)),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 16),
                DefaultTabController(
                  length: merchant.mydata.branches.length,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: TabBar(
                            indicatorColor: colors.trans,
                            isScrollable: true,
                            onTap: (int i) {
                              setState(() {
                                index += i + merchant.mydata.branches[0].id;
                              });
                            },
                            tabs: merchant.mydata.branches
                                .map((MerchantBranches tab) {
                              return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: index != tab.id
                                        ? tabBackgroundColor
                                        : colors.jokerBlue,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  child: Text(
                                    tab.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: colors.white),
                                  ));
                            }).toList()),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        width: MediaQuery.of(context).size.width,
                        height: 96,
                        child: TabBarView(
                            children: merchant.mydata.branches
                                .map((MerchantBranches tab) {
                          return Column(
                            children: <Widget>[
                              Row(children: <Widget>[
                                Image.asset(
                                  "assets/images/addreess_icon.png",
                                  scale: 3.5,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 5),
                                Text(tab.address != "null"
                                    ? tab.address
                                    : trans(context, "data_no_available"))
                              ]),
                            ],
                          );
                        }).toList()),
                      ),
                    ],
                  ),
                ),
                if (!hasMemberShip)
                  Column(
                    children: <Widget>[
                      RaisedButton(
                          color: colors.jokerBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Text(
                            trans(context, 'request_membership_for_merchant'),
                            style: styles.underHeadwhite,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: colors.jokerBlue)),
                          onPressed: () async {
                            Navigator.pushNamed(
                                context, "/MemberShipsForMerchant",
                                arguments: <String, dynamic>{
                                  "merchantId": merchant.mydata.id
                                });
                          }),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          trans(context,
                              "join_merchant_members_have_more_offers_for_qrcode_on_entrance"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: <Widget>[
                      Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                    child: SvgPicture.asset(
                                        "assets/images/vip.svg")),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      trans(context,
                                          'you_r_member_in_merchant_name'),
                                      style: styles.underHead,
                                    ),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 8, 4, 8),
                                        child: Text(
                                          trans(context, "cancel_account"),
                                          style: styles.redstyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                    child:
                                        Image.asset("assets/images/qrcode.png"))
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),
                      Text(trans(context,
                          "have_great_discounts_when_qrcode_scan_on_entrance")),
                    ],
                  )
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
        height: 40,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            color: colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(sale.merchant.salesCount.toString(),
                    style: styles.saleScreenBottomBar),
                const SizedBox(width: 12),
                Text(trans(context, "available_merchant_sales"),
                    style: styles.underHeadwhite),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: colors.white,
        radius: 24,
        child: AnimatedBuilder(
          animation: rotationController,
          builder: (_, Widget child) {
            return Transform.rotate(
              angle: rotationController.value * 2 * pi / 2,
              child: child,
            );
          },
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset("assets/images/arrowup.svg",
                color: colors.yellow),
            color: colors.white,
            onPressed: () async {
              if (isbottomSheetOpened) {
                rotationController.reverse(from: pi / 2);
                _errorController = null;
                Future<dynamic>.delayed(Duration.zero, () {
                  Navigator.pop(context);
                });
                setState(() {
                  isbottomSheetOpened = false;
                });
              } else {
                setState(() {
                  isbottomSheetOpened = true;
                });

                rotationController.forward(from: 0.0);
                _errorController =
                    scaffoldkey.currentState.showBottomSheet<dynamic>(
                  (BuildContext context) => DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    maxChildSize: 0.6,
                    minChildSize: 0.0,
                    expand: false,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      scrollController.addListener(() {});
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 16.0, color: Colors.lightBlue.shade600),
                          ),
                        ),
                        child: PagewiseListView<dynamic>(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            controller: scrollController,
                            loadingBuilder: (BuildContext context) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                              ));
                            },
                            pageSize: 15,
                            itemBuilder: (BuildContext context, dynamic entry,
                                int index) {
                              final SimpleSalesData e =
                                  entry as SimpleSalesData;
                              return Container(
                                color: index % 2 == 0
                                    ? Colors.grey[100]
                                    : Colors.grey[200],
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('${e.name}'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            e.price == "null" ? "" : e.price,
                                            style: styles.redstyleForSaleScreen,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            e.oldPrice,
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            trans(context, 'starting_date'),
                                            style: styles.mysmalllight,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(e.startAt, style: styles.mystyle)
                                        ],
                                      ),
                                      const SizedBox(width: 40),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            trans(context, 'end_date'),
                                            style: styles.mysmalllight,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(e.endAt, style: styles.mystyle)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            pageFuture: (int pageIndex) {
                              return getIt<SalesProvider>().getSimpleSalesData(
                                  pageIndexx, merchant.mydata.id);
                            }),
                      );
                    },
                  ),
                );
                _errorController.closed.then((dynamic value) {
                  rotationController.reverse(from: pi / 2);
                  isbottomSheetOpened = false;
                  _errorController = null;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getHeight();
  }
}

// ignore: must_be_immutable
class BottomWidgetForSliver extends StatefulWidget {
  BottomWidgetForSliver(
      {Key key, this.mytext, this.bottomSheetController, this.scaffoldkey})
      : super(key: key);
  final String mytext;

  final GlobalKey<ScaffoldState> scaffoldkey;
  PersistentBottomSheetController<dynamic> bottomSheetController;
  @override
  State<StatefulWidget> createState() => BottomWidgetForSliverState();
}

class BottomWidgetForSliverState extends State<BottomWidgetForSliver> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
        final TextSpan span =
            TextSpan(text: widget.mytext, style: styles.mysmall);
        final TextPainter tp = TextPainter(
          maxLines: 3,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          text: span,
        );
        tp.layout(maxWidth: size.maxWidth);
        final bool exceeded = tp.didExceedMaxLines;
        return Column(children: <Widget>[
          Text.rich(
            span,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          if (exceeded)
            InkWell(
              child: Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(trans(context, "show_more"), style: styles.showMore),
                  ],
                ),
              ),
              onTap: () {
                SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
                widget.bottomSheetController = widget.scaffoldkey.currentState
                    .showBottomSheet<dynamic>((BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.blue, width: 7.0),
                        bottom: BorderSide(color: colors.blue, width: 7.0),
                        right: BorderSide(color: colors.blue, width: 7.0),
                        left: BorderSide(color: colors.blue, width: 7.0),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
                      ),
                      color: colors.white,
                    ),
                    child: Text(widget.mytext, style: styles.mystyle),
                  );
                }, backgroundColor: Colors.transparent);
              },
            )
          else
            Container(),
        ]);
      }),
    );
  }
}

// ignore: must_be_immutable
class CurasolSlider extends StatefulWidget {
  CurasolSlider({Key key, this.sale, this.myindex}) : super(key: key);
  final SaleData sale;
  int myindex;
  @override
  _CurasolSliderState createState() => _CurasolSliderState();
}

class _CurasolSliderState extends State<CurasolSlider> {
  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(1023, 255, 112, 5)
              : const Color.fromARGB(1023, 231, 231, 232),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Stack(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: SizeConfig.screenHeight * .5,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            onPageChanged: (int index, CarouselPageChangedReason reason) {
              setState(() {
                widget.myindex = index;
              });
            },
            pageViewKey: const PageStorageKey<dynamic>('carousel_slider'),
          ),
          items: widget.sale.images.map((Images image) {
            return Builder(
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(image.imageTitle),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                const Color(0x00FFFFFF),
                                Colors.grey[200],
                              ]),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 0,
          right: 8,
          child: Column(
            crossAxisAlignment:
                isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < widget.sale.images.length; i++)
                        if (i == widget.myindex) ...<Widget>[
                          const SizedBox(height: 3),
                          circleBar(true),
                        ] else ...<Widget>[
                          const SizedBox(height: 3),
                          circleBar(false),
                        ]
                    ],
                  )),
              Text(widget.sale.name, style: styles.underHeadblack),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.sale.price ?? "30",
                    style: styles.redstyleForSaleScreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.sale.oldPrice,
                    style:
                        const TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(trans(context, "discount_details"),
                  style: styles.underHeadblack),
            ],
          ),
        )
      ],
    );
  }
  //abu talaat
}
