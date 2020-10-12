import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/ui/main/map_sales_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapAsHome extends StatefulWidget {
  const MapAsHome({Key key, this.long, this.lat}) : super(key: key);
  final double long;
  final double lat;
  @override
  _MapAsHomeState createState() => _MapAsHomeState();
}

class _MapAsHomeState extends State<MapAsHome> {
  StreamSubscription<dynamic> getPositionSubscription;
  // GoogleMapController mapController;
  // double lat;
  // double long;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Coordinates coordinates;
  List<Address> addresses;
  Address address;
  GlobalKey<ScaffoldState> _scaffoldkey;
  int specId;

  // double _panelHeightOpen;
  // final double _panelHeightClosed = 100.0;

  @override
  void initState() {
    super.initState();
    // lat = widget.lat;
    // long = widget.long;
    // _scaffoldkey = GlobalKey<ScaffoldState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<HOMEMAProvider>().getBranchesData(_scaffoldkey,
          getIt<HOMEMAProvider>().lat, getIt<HOMEMAProvider>().long, specId);
      // getIt<HOMEMAProvider>().pc.animatePanelToPosition(.3);
    });
  }

  @override
  void dispose() {
    super.dispose();
    getPositionSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
      key: getIt<HOMEMAProvider>().scaffoldkey,
      body: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldkey,
            resizeToAvoidBottomInset: false,
            body: Consumer<HOMEMAProvider>(builder:
                (BuildContext context, HOMEMAProvider value, Widget child) {
              // if (value.dataloaded) {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SlidingUpPanel(
                    // maxHeight: _panelHeightOpen,
                    // minHeight: _panelHeightClosed,
                    parallaxEnabled: true,
                    parallaxOffset: .5,
                    controller: value.pc,
                    backdropColor: colors.trans,
                    backdropOpacity: .7,
                    backdropEnabled: true,
                    header: Container(
                      decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18.0))),
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        onPressed: () {
                          print(value.pc.isPanelOpen);
                          if (value.pc.isPanelOpen) {
                            value.pc.close();
                          } else {
                            value.pc.open();
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
                                  "Explore ${getIt<HOMEMAProvider>().getSpecializationName()} Nearby",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 24.0),
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
                    onPanelSlide: (double pos) {},
                  ),
                  Positioned(
                    left: 20.0,
                    top: 40,
                    child: FloatingActionButton(
                      isExtended: false,
                      mini: true,
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: colors.white,
                    ),
                  ),
                ],
              );
              // } else {
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
            }),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    //SizedBox(height: 60),
    return MapSalesListState(sc: sc);
  }

  Future<void> _animateToUser() async {
    try {
      if (mounted) {
        await location.getLocation().then((LocationData value) {
           getIt<HOMEMAProvider>().mapController
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

  Widget _body(HOMEMAProvider value) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          indoorViewEnabled: true,
          onMapCreated: (GoogleMapController controller) async {
            serviceEnabled = await location.serviceEnabled();
            permissionGranted = await location.hasPermission();

            if (permissionGranted == PermissionStatus.denied) {
            } else {
              if (!serviceEnabled) {
              } else {
                _animateToUser();
              }
            }
            await Future<void>.delayed(const Duration(microseconds: 2000));
            value.mapController = controller;
          },
          onTap: (LatLng ll) {},
          padding: const EdgeInsets.only(bottom: 60),
          mapType: MapType.normal,
          markers: Set<Marker>.of(value.markers),
          initialCameraPosition: CameraPosition(
            target: LatLng(value.lat, value.long),
            zoom: 13,
          ),
          onCameraMove: (CameraPosition pos) {
            setState(() {
              value.lat = pos.target.latitude;
              value.long = pos.target.longitude;
            });
          },
          onCameraIdle: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 100),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 40,
              height: 40,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {},
                  child: GestureDetector(
                    child: const Center(
                      child: Icon(
                        Icons.my_location,
                        color: Color.fromARGB(1023, 150, 150, 150),
                      ),
                    ),
                    onTap: () async {
                      animateFunction();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
