import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/ui/widgets/bottom_bar.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/functions.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../localization/trans.dart';
import '../ui/widgets/my_inner_drawer.dart';
import 'main/merchant_list.dart';
import 'main/sales_list.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:joker/constants/config.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.filterData}) : super(key: key);
  final FilterData filterData;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<InnerDrawerState> key = GlobalKey<InnerDrawerState>();
  AnimationController _hide;
  GlobalKey<ScaffoldState> _scaffoldkey;
  PersistentBottomSheetController<dynamic> _errorController;
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _hide.forward();
            break;
          case ScrollDirection.reverse:
            _hide.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  String tapTitle = "";
  FilterData filterData;
  @override
  void initState() {
    super.initState();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    _hide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _hide.forward();
    filterData = widget.filterData;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final MinProvider bolc = Provider.of<MinProvider>(context, listen: false);
    //   tapTitle = bolc.bottomNavIndex == 0
    //       ? '${trans(context, 'sales')}'
    //       : '${trans(context, 'merchants')}';
    // });
  }

  @override
  Widget build(BuildContext context) {
    final MinProvider bolc = Provider.of<MinProvider>(context);
    return MyInnerDrawer(
      drawerKey: key,
      scaffold: Scaffold(
        key: _scaffoldkey,
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  forceElevated: true,
                  snap: true,
                  expandedHeight: 100.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    title: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 50,
                        ),
                        child: InkWell(
                          splashColor: colors.trans,
                          highlightColor: colors.trans,
                          onTap: () {
                            try {
                              _errorController.close();
                            } catch (e) {
                              _errorController = null;
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  bolc.bottomNavIndex == 0
                                      ? '${trans(context, 'sales')}'
                                      : '${trans(context, 'merchants')}',
                                  //  tapTitle,
                                  style: styles.saleTitle,
                                ),
                              ),
                              Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: colors.white,
                                    border: Border.all(color: colors.ggrey)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  splashColor: colors.white,
                                  onTap: () {
                                    _errorController = _scaffoldkey.currentState
                                        .showBottomSheet<dynamic>((BuildContext
                                                context) =>
                                            Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ClipPath(
                                                      clipper:
                                                          const ShapeBorderClipper(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        24),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            24)),
                                                      )),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .1),
                                                            border: const Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .orange,
                                                                    width:
                                                                        7.0))),
                                                        child: Text(
                                                          "${trans(context, 'use_current_location')}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              styles.underHead,
                                                        ),
                                                      )),
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 12),
                                                    title: Text(
                                                        "${trans(context, 'my_address_list')}"),
                                                    trailing: Icon(
                                                      Icons.search,
                                                      color: Colors.black,
                                                    ),
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/AddressList");
                                                    },
                                                  ),
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 12),
                                                    title: Text(
                                                        "${trans(context, 'use_current_location')}"),
                                                    trailing: Icon(
                                                      Icons.my_location,
                                                      color: Colors.black,
                                                    ),
                                                    onTap: () async {
                                                      final bool t =
                                                          await updateLocation;
                                                      if (t) {
                                                        Navigator.pop(context);
                                                      } else {
                                                        // should not be used
                                                        // TODO(iSLEEM): CHECK IF ITS WORKING WITHOUT SETSTATE
                                                        final List<String>
                                                            loglat =
                                                            await getLocation();
                                                        if (loglat.isEmpty) {
                                                        } else {
                                                          setState(() {
                                                            config.lat = double
                                                                .parse(loglat
                                                                    .elementAt(
                                                                        0));
                                                            config.long = double
                                                                .parse(loglat
                                                                    .elementAt(
                                                                        1));
                                                          });
                                                        }
                                                      }
                                                    },
                                                  ),
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 12),
                                                    title: Text(
                                                        "${trans(context, 'add_location')}"),
                                                    trailing: Icon(
                                                      Icons.add,
                                                      color: Colors.black,
                                                    ),
                                                    onTap: () async {
                                                      config.amIcomingFromHome =
                                                          true;
                                                      String lat;
                                                      String long;
                                                      lat = await data
                                                          .getData("lat");
                                                      long = await data
                                                          .getData("long");

                                                      await Navigator.pushNamed(
                                                          context,
                                                          '/AutoLocate',
                                                          arguments: <String,
                                                              double>{
                                                            "lat": double.parse(
                                                                    lat) ??
                                                                10.176,
                                                            "long":
                                                                double.parse(
                                                                        long) ??
                                                                    51.6565
                                                          });
                                                    },
                                                  ),
                                                  const SizedBox(height: 12),
                                                ]));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "${trans(context, 'filter')}",
                                          style: styles.smallButton,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        SvgPicture.asset(
                                          'assets/images/location.svg',
                                          height: 16,
                                          width: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  automaticallyImplyLeading: true,
                  actions: <Widget>[
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/filter.svg',
                        height: 16,
                        width: 16,
                      ),
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          headerAnimationLoop: false,
                          dialogType: DialogType.INFO,
                          animType: AnimType.BOTTOMSLIDE,
                          title: trans(context, 'clear_filter'),
                          desc: 'Clearing Filter Data',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            filterData = null;
                          },
                        ).show();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: colors.orange),
                      onPressed: () {
                        Navigator.pushNamed(context, "/AdvancedSearch");
                      },
                    ),
                    Badge(
                      position: BadgePosition.topRight(top: 16, right: 10),
                      badgeColor: colors.yellow,
                      child: IconButton(
                        icon: Icon(Icons.notifications_none,
                            color: colors.orange),
                        onPressed: () {
                          Navigator.pushNamed(context, "/Notifications");
                        },
                      ),
                    ),
                  ],
                  leading: IconButton(
                    icon: const Icon(Icons.sort, size: 30),
                    onPressed: () {
                      key.currentState.toggle();
                    },
                  ),
                ),
              ];
            },
            body: NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: Container(
                  color: colors.grey,
                  child: (bolc.bottomNavIndex == 0)
                      ? DiscountsList(filterData: filterData)
                      : ShopList()),
            )),
        bottomNavigationBar: SizeTransition(
          sizeFactor: _hide,
          child: BottomContent(),
        ),
      ),
    );
  }
}
