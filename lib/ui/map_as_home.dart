import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/ui/cards/map_card.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/util/size_config.dart';
import 'package:location/location.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/ui/main/map_sales_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../base_widget.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class MapAsHome extends StatefulWidget {
  const MapAsHome({Key key, this.long, this.lat}) : super(key: key);
  final double long;
  final double lat;
  @override
  _MapAsHomeState createState() => _MapAsHomeState();
}

class _MapAsHomeState extends State<MapAsHome> with TickerProviderStateMixin {
  StreamSubscription<dynamic> getPositionSubscription;
  StreamController<Map<String, double>> locationStreamController =
      StreamController<Map<String, double>>();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  int specId;
  PanelController pc = PanelController();

  AnimationController rotationController;
  AnimationController _animationController;
  AnimationController unUsedController;
  bool isPlaying = false;

  Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    unUsedController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await pc.hide();
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
      Navigator.pushNamed(context, "/MainMenu");
    }
  }

  bool locationWidgetShow = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BaseWidget<HOMEMAProvider>(
          onModelReady: (HOMEMAProvider modle) async {
            final Stream<Map<String, double>> stream =
                locationStreamController.stream;
            getPositionSubscription =
                stream.listen((Map<String, double> event) {
              modle.setLatLomg(event["lat"], event["long"]);
            });
            modle.controller = AnimationController(
                duration: const Duration(seconds: 2), vsync: this);
            _offsetAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, -7.5),
            ).animate(CurvedAnimation(
              parent: modle.controller,
              curve: Curves.ease,
            ));
            modle.getBranchesData(1);
            modle.pagewiseSalesController = PagewiseLoadController<dynamic>(
                pageSize: getIt<Auth>().isAuthintecated ? 15 : 6,
                pageFuture: (int pageIndex) async {
                  return modle.getSales(pageIndex);
                });
          },
          model: getIt<HOMEMAProvider>(),
          builder: (BuildContext context, HOMEMAProvider value, Widget child) =>
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SlidingUpPanel(
                    controller: pc,
                    backdropColor: colors.trans,
                    backdropOpacity: .7,
                    backdropEnabled: true,
                    onPanelClosed: () {
                      setState(() {
                        locationWidgetShow = true;
                      });
                    },
                    onPanelOpened: () {
                      setState(() {
                        locationWidgetShow = false;
                      });
                    },
                    header: Container(
                      decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18.0))),
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
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
                                      fontWeight: FontWeight.normal,
                                      fontSize: 24.0,
                                      color: Colors.black),
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
                    panelBuilder: (ScrollController sc) => _panel(sc, value),
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
                        alignment: Alignment.center,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              getIt<HOMEMAProvider>().specializations.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Color color =
                                index + 1 == value.selectedSpecialize
                                    ? colors.orange
                                    : colors.ggrey;
                            return InkWell(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: <Widget>[
                                    if (index == 0)
                                      SvgPicture.asset(
                                          "assets/images/restaurant_w.svg",
                                          color: color,
                                          height: 24,
                                          width: 24),
                                    if (index == 1)
                                      SvgPicture.asset(
                                          "assets/images/coffee_w.svg",
                                          color: color,
                                          height: 24,
                                          width: 24),
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
                  Visibility(
                      child: Positioned(

                        right: 8,
                        bottom: 120,
                        child: SlideTransition(
                          key:const Key("mIsleem") ,
                          position: _offsetAnimation,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {
                                _animateToUser(value.mapController);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Center(
                                  child:
                                      Icon(Icons.near_me, color: colors.orange),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      visible: locationWidgetShow),
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
                                      angle:
                                          rotationController.value * 2 * pi / 2,
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
                    visible: value.offersHorizontalCardsList &&
                        value.lastSales.isNotEmpty,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: SizeConfig.screenHeight / 2,
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 0),
                          child: Swiper(
                            
                            itemBuilder: (BuildContext context, int index) {
                              final SaleData rs = value.lastSales[index];
                              return MapCard(
                                  rs: rs,
                                  value: value,
                                  isAuthintecated:
                                      getIt<Auth>().isAuthintecated);
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
              )),
    );
  }

  Widget _panel(ScrollController sc, HOMEMAProvider modle) {
    return MapSalesListState(
      sc: sc,
      close: () async => await pc.close(),
      pagewiseSalesController: modle.pagewiseSalesController,
    );
  }

  Future<void> _animateToUser(GoogleMapController mapController) async {
    try {
      if (mounted) {
        await location.getLocation().then((LocationData value) {
          mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 13,
          )));

          getIt<HOMEMAProvider>().setLatLomg(value.latitude, value.longitude);
        });
      }
    } catch (e) {
      return;
    }
  }

  Widget _body(HOMEMAProvider value) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          
          // myLocationEnabled: true,
          myLocationButtonEnabled: true,
          indoorViewEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) async {
            value.mapController = controller;
            animateFunction(controller);
          },
          onTap: (LatLng ll) {},
          padding: const EdgeInsets.only(bottom: 60),
          mapType: MapType.normal,
          markers: Set<Marker>.of(value.markers),
          initialCameraPosition:
              CameraPosition(target: LatLng(config.lat, config.long), zoom: 13),
          onCameraMove: (CameraPosition pos) {
            locationStreamController.add(<String, double>{
              "lat": pos.target.latitude,
              "long": pos.target.longitude
            });
          },
          onCameraIdle: () {
            value.getBranchesData(value.selectedSpecialize);
          },
        ),
        Visibility(
          visible: value.offersHorizontalCardsList,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                heroTag: value.inFocusBranch!=null?value.inFocusBranch.id:"this_is_unique",
                isExtended: false,
                mini: true,
                child: AnimatedIcon(
                    key: const Key("unique_key"),
                    icon: AnimatedIcons.close_menu,
                    progress: unUsedController,
                    color: colors.orange),
                onPressed: () => value.onClickCloseMarker(),
                backgroundColor: colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> animateFunction(GoogleMapController mapController) async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
      } else {
        permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted == PermissionStatus.granted) {
            _animateToUser(mapController);
          }
        } else {
          _animateToUser(mapController);
        }
      }
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.granted) {
          _animateToUser(mapController);
        }
      } else {
        _animateToUser(mapController);
      }
    }
  }
}
