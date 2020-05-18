import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/ui/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../localization/trans.dart';
import '../ui/widgets/my_inner_drawer.dart';
import 'main/merchant_list.dart';
import 'main/sales_list.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<InnerDrawerState> key = GlobalKey<InnerDrawerState>();
  int tabIndex = 0;
  AnimationController _hide;
  GlobalKey<ScaffoldState> _scaffoldkey;
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

  @override
  void initState() {
    super.initState();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    _hide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _hide.forward();
  }

  @override
  Widget build(BuildContext context) {
    final MyCounter bolc = Provider.of<MyCounter>(context);
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                bolc.bottomNavIndex == 0
                                    ? '${trans(context, 'sales')}'
                                    : '${trans(context, 'merchants')}',
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
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(8),
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
                                        'assets/images/filter.svg',
                                        height: 10,
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  automaticallyImplyLeading: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add_location, color: colors.orange),
                      onPressed: () async {
                        _scaffoldkey.currentState.showBottomSheet<
                            dynamic>((BuildContext context) => Wrap(
                                direction: Axis.vertical,
                                spacing: 24,
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(24),
                                            bottomRight: Radius.circular(24)),
                                      ),
                                      child: Text(
                                        "Location Set",
                                        textAlign: TextAlign.center,
                                        style: styles.underHead,
                                      )),
                                  FlatButton(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text("Use my current Location"),
                                          Icon(Icons.my_location)
                                        ],
                                      )),
                                  FlatButton(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text("my Address list"),
                                          Icon(Icons.search)
                                        ],
                                      )),
                                  FlatButton(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/AutoLocate',
                                            arguments: <String, double>{
                                              "lat": 59.0,
                                              "long": 9.6
                                            });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text("Add new address"),
                                          Icon(Icons.add)
                                        ],
                                      )),
                                  const SizedBox(height: 12),
                                ]));
                      },
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.g_translate),
                    //   onPressed: () {
                    //     if (lang.currentLanguage == const Locale('ar')) {
                    //       lang.setLanguage(const Locale('en'));
                    //     } else {
                    //       lang.setLanguage(const Locale('ar'));
                    //     }
                    //   },
                    // ),
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
                        onPressed: () {},
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
                  child: Expanded(
                    child: (bolc.bottomNavIndex == 0)
                        ? DiscountsList()
                        : ShopList(),
                  )),
            )),
        bottomNavigationBar: SizeTransition(
          sizeFactor: _hide,
          child: BottomContent(),
        ),
      ),
    );
  }
}
