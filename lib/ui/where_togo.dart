import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/providers/globalVars.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:provider/provider.dart';
import "package:flutter/cupertino.dart";
import 'widgets/buttonTouse.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadWhereToGo extends StatelessWidget {
  const LoadWhereToGo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      return !getIt<HOMEMAProvider>().specesLoaded
          ? FutureBuilder<dynamic>(
              future: getIt<HOMEMAProvider>().getSpecializationsData(),
              builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const WhereToGo();
                } else {
                  return Container(
                      color: colors.white,
                      child: const CupertinoActivityIndicator());
                }
              },
            )
          : const WhereToGo();
    }
  }
}

class WhereToGo extends StatefulWidget {
  const WhereToGo({Key key}) : super(key: key);

  @override
  _WhereToGoState createState() => _WhereToGoState();
}

class _WhereToGoState extends State<WhereToGo>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey;
  PersistentBottomSheetController<dynamic> errorController;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    super.initState();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    distributeOnList(getIt<HOMEMAProvider>().specializations);
    if (getIt<HOMEMAProvider>().selectedSpecialize != null) {
      ts1 = styles.fromMainToListOn;
      ts2 = styles.fromMainToMapOn;
      getIt<HOMEMAProvider>().specSelected = true;
    } else {
      ts1 = styles.fromMainToList;
      ts2 = styles.fromMainToMap;
      getIt<HOMEMAProvider>().specSelected = false;
    }
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    if (!getIt<HOMEMAProvider>().specSelected) _controller.forward();
    getIt<SalesProvider>().pagewiseSalesController =
        PagewiseLoadController<dynamic>(
            pageSize: config.loggedin?15:5,
            pageFuture: (int pageIndex) async {
              return config.loggedin
                  ? (getIt<GlobalVars>().filterData != null)
                      ? getIt<SalesProvider>().getSalesDataFilterdAuthenticated(
                          pageIndex, getIt<GlobalVars>().filterData)
                      : getIt<SalesProvider>()
                          .getSalesDataAuthenticated(pageIndex)
                  : (getIt<GlobalVars>().filterData != null)
                      ? getIt<SalesProvider>().getSalesDataFilterd(
                          pageIndex, getIt<GlobalVars>().filterData)
                      : getIt<SalesProvider>().getSalesData(pageIndex);
            });
  }

  List<Widget> listviewWidgets = <Widget>[];
  TextStyle ts1 = styles.fromMainToList;
  TextStyle ts2 = styles.fromMainToMap;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomPadding: false,
      body: NestedScrollView(
        physics: const ScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              expandedHeight: 215,
              elevation: 0,
              backgroundColor: colors.trans,
              stretch: true,
              // snap: true,
              // floating: true,
              pinned: true,

              flexibleSpace: FlexibleSpaceBar(
                background: InkWell(
                  onTap: () {},
                  child: Stack(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 240,
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
                          onPageChanged:
                              (int index, CarouselPageChangedReason reason) {},
                          pageViewKey:
                              const PageStorageKey<dynamic>('carousel_slider'),
                        ),
                        items: <int>[1, 2, 3].map((int image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://thumbs.dreamstime.com/z/photo-beatch-photo-beatch-196011893.jpg"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(trans(context, 'where_do_u_want_to_go'),
                              style: styles.wheretogo),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: Consumer<HOMEMAProvider>(builder:
            (BuildContext context, HOMEMAProvider value, Widget child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(children: listviewWidgets),
                    SlideTransition(
                        position: _offsetAnimation,
                        child: middleScreenButton(value.specSelected, () {
                          Navigator.pushNamed(context, "/MapAsHome",
                              arguments: <String, dynamic>{
                                "home_map_lat": config.lat ?? 0.0,
                                "home_map_long": config.long ?? 0.0
                              });
                        }, trans(context, 'show_on_map'), Icons.map, ts2,
                            "assets/images/bg_unified_map_entrypoint.png")),
                    SlideTransition(
                        position: _offsetAnimation,
                        child: middleScreenButton(value.specSelected, () {
                          Navigator.pushNamed(context, "/Home",
                              arguments: <String, dynamic>{
                                "salesDataFilter": false,
                                "FilterData": null
                              });
                        }, trans(context, 'open_in_list'), Icons.list, ts1,
                            "assets/images/discountlist.png")),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(trans(context, 'you_have_shop'),
                          style: styles.mystyle)),
                  ButtonToUse(
                    trans(context, 'click_here'),
                    fontWait: FontWeight.bold,
                    fontColors: colors.green,
                    onPressed: () async {
                      if (await canLaunch(config.registerURL)) {
                        await launch(config.registerURL);
                      } else {
                        throw 'Could not launch ${config.registerURL}';
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // floatingActionButton: CircleAvatar(
      //   backgroundColor: colors.white,
      //   radius: 24,
      //   child: IconButton(
      //     padding: EdgeInsets.zero,
      //     icon: const Icon(Icons.add, size: 38),
      //     color: colors.yellow,
      //     onPressed: () {},
      //   ),
      // ),
    );
  }

  void distributeOnList(List<Specialization> specializations) {
    for (int i = 0; i < specializations.length; i += 2) {
      listviewWidgets.add(Row(
        children: <Widget>[
          specButton(specializations[i]),
          verticalDiv(),
          specButton(specializations[i + 1])
        ],
      ));
      listviewWidgets.add(const Divider(thickness: 1, height: 1));
      // listviewWidgets.add(const Divider(thickness: 1));
      if (i == specializations.length - 3) {
        listviewWidgets.add(Row(
          children: <Widget>[
            specButton(specializations[specializations.length - 1])
          ],
        ));
        listviewWidgets.add(const Divider(thickness: 1, height: 1));
        break;
      }
      // listviewWidgets.add(const SizedBox(height: 10));
    }
  }

  Widget verticalDiv() {
    return Container(
      child: const VerticalDivider(color: Colors.grey, thickness: 1, width: 2),
    );
  }

  Widget middleScreenButton(
      bool v, Function f, String s, IconData i, TextStyle ts, String pic) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: RaisedButton(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: !v ? colors.white.withOpacity(.5) : colors.white,
        onPressed: () {
          v ? f() : print("");
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("$s", style: ts),
                Icon(i, color: colors.blue)
              ],
            ),
            Container(
                height: 70,
                width: double.infinity,
                child: Image.asset(pic, fit: BoxFit.cover))
          ],
        ),
      ),
    );
  }

  Widget specButton(Specialization item) {
    return Consumer<HOMEMAProvider>(
      builder: (BuildContext context, HOMEMAProvider value, Widget child) {
        return Expanded(
          child: FlatButton(
            color: value.selectedSpecialize == item.id
                ? colors.blue.withOpacity(.1)
                : colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                if (item.id % 2 == 1)
                  const Icon(Icons.restaurant, size: 37)
                else
                  const Icon(Icons.local_cafe, size: 37),
                const SizedBox(height: 10),
                Text(item.name, style: styles.maingridview),
                const SizedBox(height: 20),
              ],
            ),
            onPressed: () {
              getIt<HOMEMAProvider>().setSlelectedSpec(item.id);
              setState(() {
                if (value.selectedSpecialize != null) {
                  _controller.reverse();
                  ts1 = styles.fromMainToListOn;
                  ts2 = styles.fromMainToMapOn;
                  value.specSelected = true;
                } else {
                  _controller.forward();
                  ts1 = styles.fromMainToList;
                  ts2 = styles.fromMainToMap;
                  value.specSelected = false;
                }
              });
            },
            onLongPress: () {
              Fluttertoast.showToast(
                  msg: item.name,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey[100],
                  textColor: colors.jokerBlue,
                  fontSize: 16.0);
            },
          ),
        );
      },
    );
  }
}
