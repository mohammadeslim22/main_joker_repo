import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/Merchant.dart';
import 'package:joker/util/dio.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../localization/trans.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/models/sales.dart';
import 'package:after_layout/after_layout.dart';
import 'dart:math';
import 'dart:async';

class SaleDetailPage extends StatefulWidget {
  const SaleDetailPage({Key key, this.merchantId, this.saleId})
      : super(key: key);

  final int merchantId;
  final int saleId;

  @override
  ShopDetailsPage createState() => ShopDetailsPage();
}

class ShopDetailsPage extends State<SaleDetailPage>
    with TickerProviderStateMixin {
  Merchant merchant;
  SaleData sale;

  Future<Merchant> getMerchantData(int merchentid, int saleid) async {
    final dynamic saleResult = await dio.get<dynamic>("sales/$saleid");
    sale = SaleData.fromJson(saleResult.data['data']);
    final dynamic mercantResult =
        await dio.get<dynamic>("merchants/$merchentid");
    merchant = Merchant.fromJson(mercantResult.data);
    return merchant;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Merchant>(
      future: getMerchantData(widget.merchantId, widget.saleId),
      builder: (BuildContext ctx, AsyncSnapshot<Merchant> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SaleDetails(merchant: merchant, sale: sale);
        } else {
          return const Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent));
        }
      },
    );
  }
}

class SaleDetails extends StatefulWidget {
  const SaleDetails({Key key, this.merchant, this.sale}) : super(key: key);
  final Merchant merchant;
  final SaleData sale;
  @override
  SaleDetailsPage createState() => SaleDetailsPage();
}

StreamController<double> streamController =
    StreamController<double>.broadcast();

class SaleDetailsPage extends State<SaleDetails>
    with AfterLayoutMixin<SaleDetails>, TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  int myindex = 0;
  double clientRatingStar = 0;
  bool hasMemberShip = false;

  PersistentBottomSheetController<dynamic> _errorController;
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
  PersistentBottomSheetController<dynamic> bottomSheetController;
  Merchant merchant;
  SaleData sale;
  Color tabBackgroundColor = colors.trans;

  int index = 0;
  String mytext;
  double extededPlus = 0.0;
  bool isliked;
  bool isloved;
  bool isbottomSheetOpened;

  final GlobalKey<BottomWidgetForSliverState> key =
      GlobalKey<BottomWidgetForSliverState>();
  AnimationController rotationController;
  List<Widget> items = <Widget>[];
  double angel;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        mytext = controller.text;
      });
    });
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    merchant = widget.merchant;
    sale = widget.sale;
    mytext = sale.details;
    index += merchant.mydata.branches[0].id;
    isliked = sale.isliked != 0;
    isloved = sale.isfavorite != 0;
    angel = 0.0;
    isbottomSheetOpened= false;
  }

  void getHeight() {
    final State state = key.currentState;
    final RenderBox box = state.context.findRenderObject() as RenderBox;
    setState(() {
      extededPlus = box.size.height;
    });
  }

  double position;
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
                expandedHeight: 356 + extededPlus,
                elevation: 0,
                backgroundColor: Colors.transparent,
                stretch: true,
                title: Text(trans(context, 'slae_details')),
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
                                  myindex = index;
                                });
                              },
                              pageViewKey: const PageStorageKey<dynamic>(
                                  'carousel_slider'),
                            ),
                            items: sale.images.map((Images image) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(image.imageTitle),
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
                            left: 6,
                            top: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                LikeButton(
                                  circleSize: 50,
                                  size: 31,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  countPostion: CountPostion.bottom,
                                  circleColor: CircleColor(
                                      start: Colors.blue, end: Colors.purple),
                                  isLiked: sale.isfavorite != 0,
                                  onTap: (bool loved) async {
                                    favFunction(
                                        "App\\Sale", merchant.mydata.id);
                                    isloved = !isloved;
                                    return isloved;
                                  },
                                  likeCountPadding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                ),
                                LikeButton(
                                  size: 26,
                                  likeBuilder: (bool isLiked) {
                                    return Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: !isLiked
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.blue,
                                        borderRadius: BorderRadius.circular(70),
                                      ),
                                      child: Image.asset(
                                          "assets/images/like.png",
                                          width: 10,
                                          height: 10),
                                    );
                                  },
                                  isLiked: sale.isliked != 0,
                                  likeCountPadding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  countBuilder: (int c, bool b, String count) {
                                    return Text(
                                      count,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    );
                                  },
                                  likeCount: sale.id,
                                  countPostion: CountPostion.bottom,
                                  circleColor: CircleColor(
                                      start: Colors.white, end: Colors.purple),
                                  onTap: (bool loved) async {
                                    likeFunction(
                                        "App\\Sale", merchant.mydata.id);
                                    isliked = !isliked;
                                    return isliked;
                                  },
                                ),
                                InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
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
                                              accentColor: Colors.orange,
                                              onSubmitPressed: (int rating) {
                                                setState(() {});
                                              },
                                              onAlternativePressed: () {},
                                            );
                                          });
                                    }),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: isRTL
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      children: <Widget>[
                                        for (int i = 0;
                                            i < sale.images.length;
                                            i++)
                                          if (i == myindex) ...<Widget>[
                                            const SizedBox(height: 3),
                                            circleBar(true),
                                          ] else ...<Widget>[
                                            const SizedBox(height: 3),
                                            circleBar(false),
                                          ]
                                      ],
                                    )),
                                Text(sale.name, style: styles.underHeadblack),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      sale.price ?? "30",
                                      style: styles.redstyleForSaleScreen,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      sale.oldPrice,
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough),
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
              )
            ];
          },
          body: Container(
            color: Colors.white,
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
                                index =
                                    index = i + merchant.mydata.branches[0].id;
                              });
                            },
                            tabs: merchant.mydata.branches.map((Branches tab) {
                              return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: index != tab.id
                                        ? tabBackgroundColor
                                        : colors.orange,
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
                            children:
                                merchant.mydata.branches.map((Branches tab) {
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
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 12),
                        child: RaisedButton(
                            color: colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 12),
                            child: Text(
                              trans(context, 'request_membership_for_merchant'),
                              style: styles.underHeadwhite,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: colors.orange)),
                            onPressed: () async {}),
                      ),
                      const SizedBox(height: 16),
                      Text(trans(context, "hello_")),
                      Text(trans(context, "hello_")),
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
                                      trans(
                                          context, 'you_r_member_in  resName'),
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
                      Text(trans(context, "hello_")),
                      Text(trans(context, "hello_")),
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
            color: Colors.black,
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
        backgroundColor: Colors.white,
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
            color: Colors.white,
            onPressed: () async {
              if (isbottomSheetOpened) {
                rotationController.reverse(from: pi / 2);
                _errorController.close();
                _errorController=null;
                isbottomSheetOpened = false;
              } else {
                isbottomSheetOpened = true;
                rotationController.forward(from: 0.0);
                _errorController =
                    scaffoldkey.currentState.showBottomSheet<dynamic>(
                  (BuildContext context) =>
                      //  ListView(
                      //     shrinkWrap: true,
                      //     children: <Widget>[
                      //       ClipPath(
                      //           clipper: const ShapeBorderClipper(
                      //               shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.only(
                      //                 bottomLeft: Radius.circular(24),
                      //                 bottomRight: Radius.circular(24)),
                      //           )),
                      //           child: Container(
                      //             width: MediaQuery.of(context).size.width,
                      //             decoration: BoxDecoration(
                      //                 color: Colors.black.withOpacity(.1),
                      //                 border: const Border(
                      //                     top: BorderSide(
                      //                         color: Colors.orange,
                      //                         width: 7.0))),
                      //             child: Text(
                      //               "${trans(context, 'use_current_location')}",
                      //               textAlign: TextAlign.center,
                      //               style: styles.underHead,
                      //             ),
                      //           )),
                      //       ListTile(
                      //         contentPadding: const EdgeInsets.symmetric(
                      //             horizontal: 12),
                      //         title: Text(
                      //             "${trans(context, 'my_address_list')}"),
                      //         trailing: Icon(
                      //           Icons.search,
                      //           color: Colors.black,
                      //         ),
                      //         onTap: () {
                      //           Navigator.pushNamed(
                      //               context, "/AddressList");
                      //         },
                      //       ),
                      //       ListTile(
                      //         contentPadding: const EdgeInsets.symmetric(
                      //             horizontal: 12),
                      //         title: Text(
                      //             "${trans(context, 'use_current_location')}"),
                      //         trailing: Icon(
                      //           Icons.my_location,
                      //           color: Colors.black,
                      //         ),
                      //         onTap: () {},
                      //       ),
                      //       ListTile(
                      //         contentPadding: const EdgeInsets.symmetric(
                      //             horizontal: 12),
                      //         title:
                      //             Text("${trans(context, 'add_location')}"),
                      //         trailing: Icon(
                      //           Icons.add,
                      //           color: Colors.black,
                      //         ),
                      //         onTap: () async {},
                      //       ),
                      //       const SizedBox(height: 12),
                      //     ])

                      DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    
                    maxChildSize: 0.6,
                    minChildSize: 0.0,
                    expand: false,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      scrollController.addListener(() {
                        if (scrollController.position.atEdge) {
                          rotationController.reverse(from: pi / 2);
                          _errorController.close();
                          isbottomSheetOpened = false;
                          _errorController=null;
                          print("did we close it ? ");
                        }
                      });
                      return Container(
                        height: 20,
                        color: Colors.blue[100],
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 25,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(title: Text('Item $index'));
                          },
                        ),
                      );
                    },
                  ),
                );
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
        final TextSpan span = TextSpan(
          text: widget.mytext,
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
          if (exceeded)
            InkWell(
              child: Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      trans(context, "show_more"),
                      style: TextStyle(color: Colors.blue),
                    ),
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
                      border: const Border(
                        top: BorderSide(color: Colors.orange, width: 7.0),
                        bottom: BorderSide(color: Colors.orange, width: 7.0),
                        right: BorderSide(color: Colors.orange, width: 7.0),
                        left: BorderSide(color: Colors.orange, width: 7.0),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
                      ),
                      color: Colors.white,
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
