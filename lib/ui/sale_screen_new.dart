import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/util/size_config.dart';
import 'package:provider/provider.dart';
import '../constants/styles.dart';
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
import 'package:map_launcher/map_launcher.dart' as map_luncher;

class SaleLoader extends StatefulWidget {
  const SaleLoader({Key key, this.saleData, this.merchant}) : super(key: key);

  final MapBranch merchant;
  final SaleData saleData;

  @override
  ShopDetailsPage createState() => ShopDetailsPage();
}

class ShopDetailsPage extends State<SaleLoader>
    with AfterLayoutMixin<SaleLoader>, TickerProviderStateMixin {
  MapBranch merchant;
  SaleData sale;
  double clientRatingStar = 0;
  bool hasMemberShip = false;

  PersistentBottomSheetController<dynamic> _errorController;

  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController<dynamic> bottomSheetController;
  Color tabBackgroundColor = colors.trans;
  int myIndex = 0;
  String mytext;
  double extededPlus = 20;
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
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    mytext = sale.details;
    myIndex = 0;
    isliked = sale.isliked != 0;
    isloved = sale.isfavorite != 0;
    print("is fav ${sale.isfavorite}");
    isbottomSheetOpened = false;
    pageIndexx = 1;
    // myIndex += merchant.mydata.branches[0].id;
  }

  void getHeight() {
    final State state = key.currentState;
    print("current state ${key.currentState}");
    final RenderBox box = state.context.findRenderObject() as RenderBox;
    setState(() {
      extededPlus = box.size.height + 3;
    });
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: SizeConfig.blockSizeVertical,
      width: SizeConfig.blockSizeHorizontal * 10,
      decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(1023, 255, 112, 5)
              : const Color.fromARGB(1023, 231, 231, 232),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HOMEMAProvider value =
        Provider.of<HOMEMAProvider>(context, listen: true);

    return Scaffold(
      key: scaffoldkey,
      backgroundColor: colors.white,
      body: NestedScrollView(
          physics: const ScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                expandedHeight: SizeConfig.screenHeight * .45 + extededPlus,
                elevation: 0,
                backgroundColor: colors.white,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (isbottomSheetOpened)
                            Future<dynamic>.delayed(Duration.zero, () {
                              Navigator.pop(context);
                            });
                        },
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: SizeConfig.screenHeight * .45,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (int index,
                                  CarouselPageChangedReason reason) {
                                setState(() {
                                  myIndex = index;
                                });
                              },
                              pageViewKey: const PageStorageKey<dynamic>(
                                  'carousel_slider')),
                          items: sale.images.map((Images image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(image.imageTitle),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < sale.images.length; i++)
                                if (i == myIndex) ...<Widget>[
                                  const SizedBox(height: 3),
                                  circleBar(true),
                                ] else ...<Widget>[
                                  const SizedBox(height: 3),
                                  circleBar(false),
                                ]
                            ],
                          )),
                      const SizedBox(height: 12),
                      BottomWidgetForSliver(key: key, mytext: mytext),
                    ],
                  ),
                ),
              )
            ];
          },
          body: mapCard(sale, context, value)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        color: colors.black,
        child: Align(
          alignment: Alignment.bottomCenter,
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
      floatingActionButton: CircleAvatar(
        backgroundColor: colors.grey,
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
                      return salesRELATED(scrollController);
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

  Widget salesRELATED(ScrollController scrollController) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
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
          itemBuilder: (BuildContext context, dynamic entry, int index) {
            final SimpleSalesData e = entry as SimpleSalesData;
            return Container(
              color: index % 2 == 0 ? Colors.grey[100] : Colors.grey[200],
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${e.name}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          e.price == "null" ? "" : e.price,
                          style: styles.redstyleForSaleScreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          e.oldPrice,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
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
            return getIt<SalesProvider>()
                .getSimpleSalesData(pageIndexx, merchant.merchant.id);
          }),
    );
  }

  Widget mapCard(SaleData rs, BuildContext context, HOMEMAProvider value) {
    String endsIn = "";
    String ln = "";
    String lnn = "";
    if (rs.period is! String) {
      if (rs.period[0] != 0) {
        ln = "\n";
      } else {
        lnn = "\n";
      }

      final String yearsToEnd = rs.period[0] != 0
          ? rs.period[0].toString() + " " + trans(context, 'years') + ","
          : "";
      final String monthsToEnd = rs.period[1] != 0
          ? rs.period[1].toString() + " " + trans(context, 'months') + ","
          : "";
      final String daysToEnd = rs.period[2] != 0
          ? rs.period[2].toString() + " " + trans(context, 'days') + ","
          : "";
      final String hoursToEnd = rs.period[3] != 0
          ? rs.period[3].toString() + " " + trans(context, 'hours') + ","
          : "";
      final String minutesToEnd = rs.period[4] != 0
          ? rs.period[4].toString() + " " + trans(context, 'minutes') + "."
          : "";
      endsIn =
          "$yearsToEnd $monthsToEnd  $daysToEnd $ln$hoursToEnd $minutesToEnd";
      endsIn =
          "$yearsToEnd $monthsToEnd  $ln$daysToEnd $lnn$hoursToEnd $ln$minutesToEnd";
    } else {
      endsIn = rs.period.toString();
    }
    return Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: colors.white),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: rs.mainImage,
                        errorWidget:
                            (BuildContext context, String url, dynamic error) {
                          return const Icon(Icons.error);
                        },
                        fit: BoxFit.cover,
                        height: SizeConfig.blockSizeVertical * 8,
                        width: SizeConfig.blockSizeHorizontal * 16,
                      )),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2.20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(rs.name, style: styles.saleNameInMapCard),
                        const SizedBox(height: 12),
                        Text(rs.details, style: styles.saledescInMapCard)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.star, color: colors.orange),
                        Text(value.inFocusBranch.merchant.ratesAverage
                            .toString())
                      ],
                    ),
                  )
                ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SvgPicture.asset("assets/images/discount.svg",
                            fit: BoxFit.cover,
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 12),
                        Text("  " + trans(context, 'discount') + "  ",
                            style: styles.moreInfo),
                        Text(rs.discount)
                      ]),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SvgPicture.asset("assets/images/price.svg",
                            fit: BoxFit.cover,
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 12),
                        Text("  " + rs.price + " currency",
                            style: styles.moreInfo)
                      ]),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SvgPicture.asset("assets/images/time_left.svg",
                            fit: BoxFit.cover,
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 12),
                        Text(
                            "  " +
                                rs.startAt +
                                " " +
                                trans(context, 'to') +
                                " " +
                                rs.endAt +
                                "  ",
                            style: styles.moreInfo),
                        Text(rs.status)
                      ]),
                  const SizedBox(height: 4),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SvgPicture.asset("assets/images/ends_in.svg",
                                fit: BoxFit.cover,
                                height: SizeConfig.blockSizeVertical * 5,
                                width: SizeConfig.blockSizeHorizontal * 12),
                            Text("  " + trans(context, 'ends_in') + "  ",
                                style: styles.moreInfo),
                            Container(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 2),
                                child: Text(
                                  endsIn,
                                  textAlign: TextAlign.start,
                                )),
                          ],
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LikeButton(
                                circleSize: SizeConfig.blockSizeHorizontal * 12,
                                size: SizeConfig.blockSizeHorizontal * 7,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                countPostion: CountPostion.bottom,
                                circleColor: const CircleColor(
                                    start: Colors.blue, end: Colors.purple),
                                isLiked: rs.isfavorite == 1,
                                onTap: (bool loved) async {
                                  favFunction("App\\Sale", rs.id);
                                  if (!loved) {
                                    value.setFavSale(rs.id);
                                  } else {
                                    value.setunFavSale(rs.id);
                                  }
                                  return !loved;
                                },
                                likeCountPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                              ),
                              Column(
                                children: <Widget>[
                                  const SizedBox(height: 2),
                                  LikeButton(
                                    circleSize:
                                        SizeConfig.blockSizeHorizontal * 12,
                                    size: SizeConfig.blockSizeHorizontal * 6,
                                    likeBuilder: (bool isLiked) {
                                      return Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: !isLiked
                                                ? colors.black.withOpacity(.5)
                                                : colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(70)),
                                        child: Image.asset(
                                            "assets/images/like.png",
                                            width:
                                                SizeConfig.blockSizeHorizontal,
                                            height:
                                                SizeConfig.blockSizeHorizontal),
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
                                    countPostion: CountPostion.bottom,
                                    circleColor: const CircleColor(
                                        start: Colors.white,
                                        end: Colors.purple),
                                    onTap: (bool loved) async {
                                      likeFunction("App\\Sale", rs.id);
                                      //  setState(() {
                                      isliked = !isliked;
                                      //  });

                                      return isliked;
                                    },
                                  ),
                                ],
                              )
                            ])
                      ]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            RaisedButton(
              disabledColor: colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colors.orange)),
              color: colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              onPressed: () async {
                final map_luncher.Coords crods = map_luncher.Coords(
                    value.inFocusBranch.latitude,
                    value.inFocusBranch.longitude);
                openMapsSheet(context, crods);
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("G", style: styles.googlemapsG),
                const Text("  "),
                Text(trans(context, 'maps'), style: styles.maps)
              ]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 12),
                const Expanded(
                    child: Divider(color: Colors.grey, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(trans(context, "merchant"),
                      style: styles.underHeadblack),
                ),
                const Expanded(
                    child: Divider(color: Colors.grey, thickness: 1)),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              child: CachedNetworkImage(
                                // height: SizeConfig.blockSizeVertical * 5,
                                placeholderFadeInDuration:
                                    const Duration(milliseconds: 300),
                                imageUrl: merchant.merchant.logo,
                                imageBuilder: (BuildContext context,
                                        ImageProvider imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover)),
                                ),
                                placeholder:
                                    (BuildContext context, String url) =>
                                        const CircularProgressIndicator(),
                                errorWidget: (BuildContext context, String url,
                                        dynamic error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(merchant.merchant.name,
                                style: styles.underHead),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (!hasMemberShip)
              Column(
                children: <Widget>[
                  RaisedButton(
                      color: colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                          trans(context, 'request_membership_for_merchant'),
                          style: styles.underHeadwhite),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: colors.orange)),
                      onPressed: () async {
                        Navigator.pushNamed(context, "/MemberShipsForMerchant",
                            arguments: <String, dynamic>{
                              "merchantId": merchant.merchant.id
                            });
                      }),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                child:
                                    SvgPicture.asset("assets/images/vip.svg")),
                            Column(
                              children: <Widget>[
                                Text(
                                  trans(
                                      context, 'you_r_member_in_merchant_name'),
                                  style: styles.underHead,
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 8, 4, 8),
                                    child: Text(
                                      trans(context, "cancel_account"),
                                      style: styles.redstyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                                child: Image.asset("assets/images/qrcode.png"))
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  Text(trans(context,
                      "have_great_discounts_when_qrcode_scan_on_entrance")),
                ],
              )
          ],
        ));
  }

  dynamic openMapsSheet(BuildContext context, map_luncher.Coords coords) async {
    try {
      const String title = "Ocean Beach";
      final List<map_luncher.AvailableMap> availableMaps =
          await map_luncher.MapLauncher.installedMaps;

      showModalBottomSheet<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (map_luncher.AvailableMap map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getHeight();
  }
}

class BottomWidgetForSliver extends StatefulWidget {
  const BottomWidgetForSliver({Key key, this.mytext}) : super(key: key);
  final String mytext;
  @override
  State<StatefulWidget> createState() => BottomWidgetForSliverState();
}

class BottomWidgetForSliverState extends State<BottomWidgetForSliver> {
  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
        final TextSpan span =
            TextSpan(text: widget.mytext, style: styles.mysmall);
        final TextPainter tp = TextPainter(
            maxLines: 2, textDirection: TextDirection.ltr, text: span);
        tp.layout(maxWidth: size.maxWidth);
        final bool exceeded = tp.didExceedMaxLines;
        return Column(children: <Widget>[
          Text.rich(span, overflow: TextOverflow.ellipsis, maxLines: 3),
          InkWell(
            onTap: () {
              showFullText(context, widget.mytext);
            },
            child: Visibility(
                child: Container(
                    alignment:
                        isRTL ? Alignment.centerLeft : Alignment.centerRight,
                    height: SizeConfig.blockSizeVertical * 2,
                    child: Text(trans(context, "show_more"),
                        style: styles.showMore)),
                visible: exceeded,
                replacement: Container()),
          )
        ]);
      }),
    );
  }
}

//abu talaat
