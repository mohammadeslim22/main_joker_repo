import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/Merchant.dart';
import 'package:joker/util/dio.dart';
import 'package:rating_bar/rating_bar.dart';
import '../localization/trans.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';

class SaleDetailPage extends StatefulWidget {
  const SaleDetailPage({Key key, this.merchantId}) : super(key: key);

  final int merchantId;

  @override
  ShopDetailsPage createState() => ShopDetailsPage();
}

class ShopDetailsPage extends State<SaleDetailPage>
    with TickerProviderStateMixin {
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
            return SaleDetails(merchant: merchant);
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

class SaleDetails extends StatefulWidget {
  const SaleDetails({Key key, this.merchant}) : super(key: key);
  final Merchant merchant;
  @override
  SaleDetailsPage createState() => SaleDetailsPage();
}

class SaleDetailsPage extends State<SaleDetails> with TickerProviderStateMixin {
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  TextEditingController controller = TextEditingController();
  int myindex = 0;
  double _ratingStar = 0;
  double clientRatingStar = 0;
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

  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController<dynamic> _errorController;
  Merchant merchant;
  Color tabBackgroundColor = colors.trans;
  TabController _tabController;
  int index = 2;
  String mytext =
      "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها. ولذلك يتم استخدام طريقة لوريم إيبسوم لأنها تعطي توزيعاَ طبيعياَ -إلى حد ما- للأحرف عوضاً عن استخدام  فتجعلها تبدو (أي الأحرف) وكأنها نص مقروء. العديد من برامح النشر المكتبي وبرامح تحرير صفحات الويب تستخدم لوريم إيبسوم بشكل إفتراضي كنموذج عن النص، وإذا قمت بإدخال  في أي محرك بحث ستظهر العديد من المواقع الحديثة العهد في نتائج البحث. على مدى السنين ظهرت نسخ جديدة ومختلفة من نص لوريم إيبسوم، أحياناً عن طريق الصدفة، وأحياناً عن عمد كإدخال بعض العبارات الفكاهية إليها.";
  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        mytext = controller.text;
      });
    });
    merchant = widget.merchant;
    _tabController =
        TabController(vsync: this, length: merchant.mydata.branches.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
      } else if (_tabController.index != _tabController.previousIndex) {}
    });
  }

  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
        key: scaffoldkey,
        body: NestedScrollView(
            physics: const ScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 452,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  stretch: true,
                  title: AppBar(
                      title: Text(trans(context, 'slae_details')),
                      centerTitle: true,
                      backgroundColor: Colors.transparent),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 380,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                //   enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (int index,
                                    CarouselPageChangedReason reason) {
                                  setState(() {
                                    myindex = index;
                                  });
                                },
                                pageViewKey: const PageStorageKey<dynamic>(
                                    'carousel_slider'),
                              ),
                              items: <String>[
                                "logo",
                                "logo",
                                "logo",
                                "logo",
                                "logo"
                              ].map((dynamic i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: <Widget>[
                                        Container(
                                          child: Image.asset(
                                            "assets/images/discountbackground.png",
                                            width: double.infinity,
                                            fit: BoxFit.cover,
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
                              left: 6,
                              top: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  LikeButton(
                                    size: 26,
                                    likeBuilder: (bool isLiked) {
                                      return Container(
                                        key: key,
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
                                          height: 10,
                                        ),
                                      );
                                    },
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
                                    likeCount: 50,
                                    countPostion: CountPostion.bottom,
                                    circleColor: CircleColor(
                                        start: Colors.white,
                                        end: Colors.purple),
                                    onTap: (bool loved) {
                                      return onLikeButtonTapped(loved);
                                    },
                                  ),
                                  LikeButton(
                                    size: 31,
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
                                    likeCount: 50,
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
                            ),
                            Positioned(
                              top: 210,
                              right: 8,
                              // height: 160,
                              // width: 150,
                              child: Column(
                                crossAxisAlignment: isRTL
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                // padding: const EdgeInsets.all(0),
                                // physics: const ScrollPhysics(),
                                // shrinkWrap: true,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        children: <Widget>[
                                          for (int i = 0; i < 5; i++)
                                            if (i == myindex) ...<Widget>[
                                              const SizedBox(height: 3),
                                              circleBar(true),
                                            ] else ...<Widget>[
                                              const SizedBox(height: 3),
                                              circleBar(false),
                                            ]
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: RatingBar(
                                        onRatingChanged: (double rating) {
                                          setState(() => _ratingStar = rating);
                                          // TODO(mislem): use this var to send raiting to API
                                          print(_ratingStar);
                                        },
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        halfFilledIcon: Icons.star_half,
                                        isHalfAllowed: true,
                                        filledColor: Colors.amberAccent,
                                        emptyColor: Colors.grey,
                                        halfFilledColor: Colors.orange[300],
                                        size: 20,
                                      )),
                                  const SizedBox(height: 8),
                                  Text("Sale Name",
                                      style: styles.underHeadblack),
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                          "assets/images/redaddreess_icon.png",
                                          scale: 3.5,
                                          fit: BoxFit.cover),
                                      const SizedBox(width: 8),
                                      Text("City", style: styles.mystyle),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Discount Details",
                                      style: styles.underHeadblack),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LayoutBuilder(builder:
                              (BuildContext context, BoxConstraints size) {
                            final TextSpan span = TextSpan(
                              text: mytext,
                              style: styles.mysmall,
                            );
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
                              InkWell(
                                child: Container(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        exceeded
                                            ? trans(context, "show_more")
                                            : "",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  _errorController = scaffoldkey.currentState
                                      .showBottomSheet<dynamic>(
                                          (BuildContext context) {
                                    SystemChannels.textInput
                                        .invokeMethod<String>('TextInput.hide');
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      child:
                                          Text(mytext, style: styles.mystyle),
                                    );
                                  });
                                },
                              ),
                            ]);
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ListView(
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
                            Text("merchant.name", style: styles.mysmall),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/images/merchants.svg",
                                  color: colors.black,
                                ),
                                const SizedBox(width: 12),
                                Text("merchant.name", style: styles.underHead),
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
                              onRatingChanged: (double rating) =>
                                  setState(() => clientRatingStar = rating),
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                              halfFilledIcon: Icons.star_half,
                              isHalfAllowed: true,
                              filledColor: Colors.amberAccent,
                              emptyColor: Colors.grey,
                              halfFilledColor: Colors.orange[300],
                              size: 20,
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
                                  SvgPicture.asset(
                                    "assets/images/redarrow.svg",
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
                    Container(height: 30, width: 3, color: Colors.orange),
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
                    //  const SizedBox(height: 12),
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
                      right: 100,
                      left: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const SizedBox(width: 7),
                          Column(
                            children: <Widget>[
                              Text(trans(context, "from")),
                              const SizedBox(height: 7),
                              Text(
                                "2020-4-1",
                                style: styles.mystyle,
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(trans(context, "to")),
                              const SizedBox(height: 7),
                              Text(
                                "2020-6-11",
                                style: styles.mystyle,
                              )
                            ],
                          ),
                          const SizedBox(width: 7),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/images/arrow_andclipped_line.svg",
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        trans(context, "sale_is_available_in_branches"),
                        style: styles.underHeadblack,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                // Column(
                //   children: <Widget>[
                //     Container(
                //       padding: const EdgeInsets.symmetric(vertical: 8),
                //       color: Colors.grey[300],
                //       child: TabBar(
                //           indicatorColor: colors.trans,
                //           isScrollable: true,
                //           onTap: (int i) {
                //             setState(() {
                //               index = i;
                //             });
                //           },
                //           controller: _tabController,
                //           tabs: merchant.mydata.branches.map((Branches tab) {
                //             return Container(
                //                 decoration: BoxDecoration(
                //                   borderRadius: const BorderRadius.all(
                //                       Radius.circular(8)),
                //                   color: _tabController.index != tab.id
                //                       ? tabBackgroundColor
                //                       : colors.orange,
                //                 ),
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 5, vertical: 8),
                //                 child: Text(
                //                   tab.name,
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                     color: _tabController.index != tab.id
                //                         ? Colors.black
                //                         : colors.orange,
                //                   ),
                //                 ));
                //           }).toList()),
                //     ),
                //     Container(
                //       color: Colors.white,
                //       padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                //       width: MediaQuery.of(context).size.width,
                //       height: 96,
                //       child: TabBarView(
                //           controller: _tabController,
                //           children:
                //               merchant.mydata.branches.map((Branches tab) {
                //             return Column(
                //               children: <Widget>[
                //                 Row(children: <Widget>[
                //                   Image.asset(
                //                     "assets/images/addreess_icon.png",
                //                     scale: 3.5,
                //                     fit: BoxFit.cover,
                //                   ),
                //                   const SizedBox(width: 5),
                //                   Text(tab.address)
                //                 ]),
                //               ],
                //             );
                //           }).toList()),
                //     ),
                //   ],
                // ),
              ],
            )));
  }
}
