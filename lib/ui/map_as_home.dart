import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/globalVars.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/providers/merchantsProvider.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/util/size_config.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/ui/main/map_sales_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LoadWhereToGo extends StatelessWidget {
  const LoadWhereToGo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      return FutureBuilder<dynamic>(
        future: getIt<HOMEMAProvider>().getSpecializationsData(),
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MapAsHome(lat: config.lat ?? 0.0, long: config.long ?? 0.0);
          } else {
            return Container(
              color: colors.white,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset("assets/images/joker_indirim.svg",
                        fit: BoxFit.cover),
                    const SizedBox(height: 12),
                    const CupertinoActivityIndicator(radius: 24)
                  ],
                ),
              ),
            );
          }
        },
      );
    }
  }
}

class MapAsHome extends StatefulWidget {
  const MapAsHome({Key key, this.long, this.lat}) : super(key: key);
  final double long;
  final double lat;
  @override
  _MapAsHomeState createState() => _MapAsHomeState();
}

class _MapAsHomeState extends State<MapAsHome> with TickerProviderStateMixin {
  StreamSubscription<dynamic> getPositionSubscription;

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  GlobalKey<ScaffoldState> _scaffoldkey;
  int specId;
  static PanelController pc = PanelController();
  AnimationController rotationController;
  AnimationController _animationController;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await pc.hide();
    });
    getIt<HOMEMAProvider>().getBranchesData(_scaffoldkey, 1);
    getIt<SalesProvider>().pagewiseSalesController =
        PagewiseLoadController<dynamic>(
            pageSize: config.loggedin ? 15 : 6,
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
    getIt<MerchantProvider>().pagewiseBranchesController =
        PagewiseLoadController<dynamic>(
            pageSize: 5,
            pageFuture: (int pageIndex) async {
              return config.loggedin
                  ? getIt<MerchantProvider>()
                      .getBranchesDataAuthintecated(pageIndex)
                  : getIt<MerchantProvider>().getBranchesData(pageIndex);
            });
  }

  @override
  void dispose() {
    super.dispose();
    getPositionSubscription?.cancel();
  }

  void _handleOnPressed(HOMEMAProvider value) {
    if (value.showSlidingPanel && !value.showSepcializationsPad) {
      pc.hide();
      value.makeshowSlidingPanelFalse();
      value.makeShowSepcializationsPadTrue();
      value.hideOffersHorizontalCards();
      _animationController.reverse();
    } else {
      Fluttertoast.showToast(msg: "TODO: open menu");
      //open menu
      // _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: getIt<HOMEMAProvider>().scaffoldkey,
      resizeToAvoidBottomInset: false,
      body: Consumer<HOMEMAProvider>(
          builder: (BuildContext context, HOMEMAProvider value, Widget child) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              controller: pc,
              backdropColor: colors.trans,
              backdropOpacity: .7,
              backdropEnabled: true,
              renderPanelSheet: false,
              header: Container(
                decoration: BoxDecoration(
                    color: colors.white,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(18.0))),
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  onPressed: () async {
                    if (pc.isPanelOpen) {
                      await pc.close();
                    } else {
                      await pc.open();
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            trans(context, 'explore') +
                                " ${value.getSpecializationName()} " +
                                trans(context, 'nearby'),
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 24.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      const Divider(thickness: 1)
                    ],
                  ),
                ),
              ),
              body: _body(value),
              panelBuilder: (ScrollController sc) => _panel(sc),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            ),
            Positioned(
              left: SizeConfig.blockSizeHorizontal * 2,
              top: SizeConfig.blockSizeVertical * 4,
              child: FloatingActionButton(
                isExtended: false,
                mini: true,
                child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                    color: colors.orange),
                onPressed: () => _handleOnPressed(value),
                backgroundColor: colors.white,
              ),
            ),
            Visibility(
              visible: value.showSepcializationsPad,
              child: Positioned(
                left: 8.0,
                right: 8.0,
                bottom: 12,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: colors.white),
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: getIt<HOMEMAProvider>().specializations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Color color = index + 1 == value.selectedSpecialize
                          ? colors.orange
                          : colors.ggrey;
                      return InkWell(
                        child: Container(
                          // height: SizeConfig.blockSizeVertical * 10,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.ac_unit, color: color),
                              const SizedBox(height: 8),
                              Text(
                                  getIt<HOMEMAProvider>()
                                      .specializations[index]
                                      .name,
                                  style: TextStyle(color: color)),
                            ],
                          ),
                        ),
                        onTap: () {
                          value.setSlelectedSpec(index + 1);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: !value.offersHorizontalCardsList ? 120 : 360,
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    _animateToUser();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: Icon(Icons.near_me, color: colors.orange),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !value.showSlidingPanel,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      left: 0,
                      top: SizeConfig.blockSizeVertical * 20,
                      child: InkWell(
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 8,
                            width: SizeConfig.blockSizeHorizontal * 8,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: colors.orange,
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(12),
                                    topRight: Radius.circular(12))),
                            padding: const EdgeInsets.only(
                                left: 4, top: 4, bottom: 0),
                            child: RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  trans(context, 'offers'),
                                  style: TextStyle(
                                      fontSize: 14, color: colors.white),
                                )),
                          ),
                          onTap: () async {
                            value.makeshowSlidingPanelTrue();
                            value.makeShowSepcializationsPadFalse();
                            value.hideOffersHorizontalCards();
                            await pc.show();
                            pc.open();
                            _animationController.forward();
                          })),
                  Positioned(
                    left: SizeConfig.blockSizeHorizontal * 5,
                    top: SizeConfig.blockSizeVertical * 22.25,
                    child: InkWell(
                      onTap: () async {
                        value.makeshowSlidingPanelTrue();
                        value.makeShowSepcializationsPadFalse();
                        value.hideOffersHorizontalCards();
                        await pc.show();
                        pc.open();
                        _animationController.forward();
                      },
                      child: CircleAvatar(
                        backgroundColor: colors.orange,
                        radius: 10,
                        child: AnimatedBuilder(
                          animation: rotationController,
                          builder: (_, Widget child) {
                            return Transform.rotate(
                                angle: rotationController.value * 2 * pi / 2,
                                child: child);
                          },
                          child: RotatedBox(
                              quarterTurns: 1,
                              child: SvgPicture.asset(
                                  "assets/images/arrowup.svg",
                                  color: colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible:
                  value.offersHorizontalCardsList && value.lastSales.isNotEmpty,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: SizeConfig.screenHeight / 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        final SaleData rs = value.lastSales[index];
                        return mapCard(rs);
                      },
                      itemCount: value.lastSales.length,
                      viewportFraction: .8,
                      scale: 0.85,
                      loop: false,
                      controller: value.swipController,
                    )),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget mapCard(SaleData rs) {
    return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32), color: colors.white),
        child: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(rs.name, style: styles.saleNameInMapCard),
                      const SizedBox(height: 12),
                      Text(rs.details, style: styles.saledescInMapCard)
                    ],
                  )
                ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              SvgPicture.asset("assets/images/discount_incard.svg",
                  fit: BoxFit.cover,
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 12),
              Text("  " + trans(context, 'discount') + " 50%")
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              SvgPicture.asset("assets/images/price.svg",
                  fit: BoxFit.cover,
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 12),
              Text("  " + rs.price + " currency")
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              SvgPicture.asset("assets/images/time_left.svg",
                  fit: BoxFit.cover,
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 12),
              Text("  " +
                  rs.startAt +
                  " " +
                  trans(context, 'to') +
                  " " +
                  rs.endAt +
                  " (${rs.status})")
            ]),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              SvgPicture.asset(
                "assets/images/ends_in.svg",
                fit: BoxFit.cover,
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 12,
              ),
              Text("  " + trans(context, 'ends_in') + "  " + rs.period)
            ]),
            const SizedBox(height: 4),
            RaisedButton(
              disabledColor: colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colors.orange)),
              color: colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              onPressed: () {},
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("G", style: styles.googlemapsG),
                const Text("  "),
                Text(trans(context, 'maps'), style: styles.maps)
              ]),
            ),
          ],
        ));
  }
  // Widget _buildCarousel(BuildContext context) {
  //   return SizedBox(
  //     // you may want to use an aspect ratio here for tablet support
  //     height: 200.0,
  //     child: PageView.builder(
  //       // store this controller in a State to save the carousel scroll position
  //       controller: PageController(viewportFraction: 0.8),
  //       itemBuilder: (BuildContext context, int itemIndex) {
  //         return Transform.scale(
  //               scale: i == itemIndex ? 1 : 0.9,
  //               child:_buildCarouselItem(context, itemIndex));
  //       },
  //     ),
  //   );
  // }

  // Widget _buildCarouselItem(BuildContext context, int itemIndex) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //     child: Container(
  //       decoration: const BoxDecoration(
  //         color: Colors.grey,
  //         borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //       ),
  //     ),
  //   );
  // }

  Widget _panel(ScrollController sc) {
    return MapSalesListState(sc: sc, close: () async => await pc.close());
  }

  Future<void> _animateToUser() async {
    try {
      if (mounted) {
        await location.getLocation().then((LocationData value) {
          getIt<HOMEMAProvider>()
              .mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 13,
              )));

          getIt<HOMEMAProvider>().lat = value.latitude;
          getIt<HOMEMAProvider>().long = value.longitude;
        });
      }
    } catch (e) {
      return;
    }
  }

  Widget _body(HOMEMAProvider value) {
    return GoogleMap(
      // myLocationEnabled: true,
      myLocationButtonEnabled: true,
      indoorViewEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) async {
        serviceEnabled = await location.serviceEnabled();
        permissionGranted = await location.hasPermission();
        value.mapController = controller;
        if (permissionGranted == PermissionStatus.denied) {
        } else {
          if (!serviceEnabled) {
          } else {
            //  _animateToUser();
          }
        }
      },
      onTap: (LatLng ll) {
        //   value.showOffersHorizontalCards();
      },
      padding: const EdgeInsets.only(bottom: 60),
      mapType: MapType.normal,
      markers: Set<Marker>.of(value.markers),
      initialCameraPosition:
          CameraPosition(target: LatLng(config.lat, config.long), zoom: 13),
      onCameraMove: (CameraPosition pos) {
        value.lat = pos.target.latitude;
        value.long = pos.target.longitude;
      },
      onCameraIdle: () {
        getIt<HOMEMAProvider>().getBranchesData(_scaffoldkey, value.selectedSpecialize);
      },
    );
  }

  Future<void> animateFunction() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
      } else {
        permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted == PermissionStatus.granted) {
            _animateToUser();
          }
        } else {
          _animateToUser();
        }
      }
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.granted) {
          _animateToUser();
        }
      } else {
        _animateToUser();
      }
    }
  }
}
