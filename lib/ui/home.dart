import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joker/base_widget.dart';
import 'package:joker/providers/home_modle.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/ui/widgets/bottom_bar.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/functions.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../localization/trans.dart';
import '../ui/widgets/my_inner_drawer.dart';
import 'main/merchant_list_statless.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'main/sales_list_stateless.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    _hide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _hide.forward();
    // final SalesProvider sModle = getIt<SalesProvider>();
    // final MerchantProvider mModle = getIt<MerchantProvider>();

    // mModle.pagewiseBranchesController = PagewiseLoadController<dynamic>(
    //     pageSize: 5,
    //     pageFuture: (int pageIndex) async {
    //       return getIt<Auth>().isAuthintecated
    //           ? mModle.getBranchesDataAuthintecated(pageIndex)
    //           : mModle.getBranchesData(pageIndex);
    //     });

    // sModle.pagewiseHomeSalesController = PagewiseLoadController<dynamic>(
    //     pageSize: getIt<Auth>().isAuthintecated ? 15 : 6,
    //     pageFuture: (int pageIndex) async {
    //       return getIt<Auth>().isAuthintecated
    //           ? salesDataFilter
    //               ? sModle.getSalesDataFilterdAuthenticated(
    //                   pageIndex, widget.filterData)
    //               : sModle.getSalesDataAuthenticatedAllSpec(pageIndex)
    //           : salesDataFilter
    //               ? sModle.getSalesDataFilterd(pageIndex, widget.filterData)
    //               : sModle.getSalesDataAllSpec(pageIndex);
    //     });
  }

  @override
  Widget build(BuildContext context) {
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
                                  getIt<HomeModle>().bottomNavIndex == 0
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
                                  onTap: () {
                                    _errorController = _scaffoldkey.currentState
                                        .showBottomSheet<dynamic>(
                                            (BuildContext context) =>
                                                locationBottomSheet());
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
                                        const SizedBox(width: 4),
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
                    // IconButton(
                    //   icon: Icon(Icons.map, color: colors.orange),
                    //   onPressed: () {
                    //     if (_errorController != null) {
                    //       Navigator.pop(context);
                    //       goToMap(context);
                    //     } else {
                    //       goToMap(context);
                    //     }
                    //   },
                    // ),
                    IconButton(
                      icon: Icon(Icons.clear, color: colors.orange),
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
                            getIt<SalesProvider>().clearilterDate();
                            getIt<SalesProvider>()
                                .pagewiseHomeSalesController
                                .reset();
                          },
                        ).show();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: colors.orange),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, "/AdvancedSearch",
                            arguments: <String, dynamic>{
                              "specializations":
                                  getIt<HOMEMAProvider>().specializations
                            });
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.camera, color: colors.orange),
                      onPressed: () async {
                        final String barcodeScanRes =
                            await FlutterBarcodeScanner.scanBarcode(
                                "#ff6666", "Cancel", true, ScanMode.QR);
                        try {
                          final Map<String, dynamic> map = json
                              .decode(barcodeScanRes) as Map<String, dynamic>;
                          getIt<MerchantProvider>().vistBranch(
                              int.parse(map['id'].toString()),
                              source: 'qr');
                          Navigator.pushNamed(context, "/MerchantDetails",
                              arguments: <String, dynamic>{
                                "merchantId":
                                    int.parse(map['merchant_id'].toString()),
                                "branchId": int.parse(map['id'].toString()),
                                "source": "qr"
                              });
                          Fluttertoast.showToast(msg: barcodeScanRes);
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: trans(context, 'use_right_qr_code'));
                        }
                      },
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
                child: BaseWidget<HomeModle>(
                  model: getIt<HomeModle>(),
                  builder:
                      (BuildContext context, HomeModle modle, Widget child) =>
                          Container(
                              color: colors.grey,
                              child: (modle.bottomNavIndex == 0)
                                  ? DiscountsListStateless()
                                  : ShopListStaeless()),
                ))),
        bottomNavigationBar: SizeTransition(
          sizeFactor: _hide,
          child: BottomContent(),
        ),
      ),
    );
  }

  Widget locationBottomSheet() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ClipPath(
          clipper: const ShapeBorderClipper(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24)),
          )),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.1),
                border:
                    Border(top: BorderSide(color: colors.orange, width: 7.0))),
            child: Text(
              "${trans(context, 'location_setting')}",
              textAlign: TextAlign.center,
              style: styles.underHead,
            ),
          )),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text("${trans(context, 'my_address_list')}"),
        trailing: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        onTap: () {
          Navigator.pushNamed(context, "/AddressList");
        },
      ),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text("${trans(context, 'use_current_location')}"),
        trailing: const Icon(Icons.my_location, color: Colors.black),
        onTap: () async {
          final Map<String, dynamic> location = await updateLocation;

          final bool t = location["res"] as bool;
          final List<String> loglat = location["location"] as List<String>;
          if (t) {
            getIt<HOMEMAProvider>().setLatLomg(
                double.parse(loglat.elementAt(0)),
                double.parse(loglat.elementAt(1)));

            Navigator.pop(context);
            getIt<MerchantProvider>().pagewiseBranchesController.reset();
            getIt<SalesProvider>().pagewiseHomeSalesController.reset();
          } else {
            Fluttertoast.showToast(
                msg: trans(context, "unable_to_get_location"));
            Navigator.pop(context);
          }
        },
      ),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text("${trans(context, 'set_from_map')}"),
        trailing: Icon(Icons.add, color: colors.black),
        onTap: () async {
          config.amIcomingFromHome = true;
          String lat;
          String long;
          lat = await data.getData("lat");
          long = await data.getData("long");

          await Navigator.pushNamed(context, '/AutoLocate',
              arguments: <String, dynamic>{
                "lat": double.parse(lat) ?? 10.176,
                "long": double.parse(long) ?? 51.6565,
                "choice": 1
              });
        },
      ),
      const SizedBox(height: 12),
    ]);
  }
}
