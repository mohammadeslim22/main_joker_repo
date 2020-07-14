import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:joker/models/specializations.dart';
import '../constants/styles.dart';

class HOMEMAP extends StatefulWidget {
  const HOMEMAP({Key key, this.long, this.lat}) : super(key: key);
  final double long;
  final double lat;
  @override
  _HOMEMAPState createState() => _HOMEMAPState();
}

class _HOMEMAPState extends State<HOMEMAP> {
  StreamSubscription<dynamic> getPositionSubscription;
  GoogleMapController mapController;
  Location location = Location();
  double lat;
  double long;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<String> choices;
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  Coordinates coordinates;
  List<Address> addresses;
  Address address;
  @override
  void initState() {
    super.initState();
    lat = widget.lat ?? 34;
    long = widget.long ?? 31;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      choices = <String>[trans(context, "home"), trans(context, "exit")];

      getIt<HOMEMAProvider>().getBranchesData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    getPositionSubscription?.cancel();
  }

  Future<void> getLocationName(double long, double lat) async {
    try {
      coordinates = Coordinates(lat, long);
      addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      setState(() => address = addresses.first);
      print('fetched ${address.addressLine}');
    } catch (e) {
      address = null;
    }
  }

  Future<bool> _willPopCallback() async {
    Provider.of<MainProvider>(context, listen: false)
        .togelocationloading(false);
    Navigator.pop(context);
    return true;
  }

  Future<void> tryToAnimate() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
    } else {
      _animateToUser();
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
      } else {
        _animateToUser();
      }
    }
  }

  Set<int> selectedOptions = <int>{};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Stack(
          children: <Widget>[
            Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                body: Consumer<HOMEMAProvider>(builder:
                    (BuildContext context, HOMEMAProvider value, Widget child) {
                  if (value.dataloaded) {
                    return Stack(
                      children: <Widget>[
                        GoogleMap(
                          circles: <Circle>{
                            Circle(
                                circleId: CircleId("id"),
                                center: LatLng(lat, long),
                                fillColor: Colors.blue.withOpacity(.3),
                                radius: 4000,
                                strokeColor: Colors.transparent,
                                zIndex: 20,
                                strokeWidth: 2)
                          },
                          onMapCreated: (GoogleMapController controller) async {
                            serviceEnabled = await location.serviceEnabled();
                            if (!serviceEnabled) {
                            } else {
                              permissionGranted =
                                  await location.hasPermission();
                              if (permissionGranted ==
                                  PermissionStatus.denied) {
                              } else {
                                _animateToUser();
                              }
                            }
                            // await Future<void>.delayed(
                            //   const Duration(seconds: 1));
                            mapController = controller;
                            Timer(Duration(seconds: 2), () {
                              value.markers.keys.forEach((MarkerId element) {
                                print(element.value);
                                controller.showMarkerInfoWindow(element);
                                print("how many marker id we have ? $element");
                              });
                            });
                          },
                          padding: const EdgeInsets.only(bottom: 60),
                          mapType: MapType.normal,
                          markers: Set<Marker>.of(
                              getIt<HOMEMAProvider>().markers.values),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(lat, long),
                            zoom: 13,
                          ),
                          onCameraMove: (CameraPosition pos) {
                            setState(() {
                              lat = pos.target.latitude;
                              long = pos.target.longitude;
                            });
                          },
                          onCameraIdle: () {
                            setState(() {
                              getIt<HOMEMAProvider>().getBranchesData();
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 69),
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
                                    child: Center(
                                      child: Icon(
                                        Icons.my_location,
                                        color: const Color.fromARGB(
                                            1023, 150, 150, 150),
                                      ),
                                    ),
                                    onTap: () async {
                                      serviceEnabled =
                                          await location.serviceEnabled();
                                      if (!serviceEnabled) {
                                        serviceEnabled =
                                            await location.requestService();
                                        if (!serviceEnabled) {
                                        } else {
                                          permissionGranted =
                                              await location.hasPermission();
                                          if (permissionGranted ==
                                              PermissionStatus.denied) {
                                            permissionGranted = await location
                                                .requestPermission();
                                            if (permissionGranted ==
                                                PermissionStatus.granted) {
                                              _animateToUser();
                                            }
                                          } else {
                                            _animateToUser();
                                          }
                                        }
                                      } else {
                                        permissionGranted =
                                            await location.hasPermission();
                                        if (permissionGranted ==
                                            PermissionStatus.denied) {
                                          permissionGranted = await location
                                              .requestPermission();
                                          if (permissionGranted ==
                                              PermissionStatus.granted) {
                                            _animateToUser();
                                          }
                                        } else {
                                          print("iam fucked up");
                                          _animateToUser();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    children: value.specializations
                                        .map((Specializations item) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child:
                                            //  Text("${item.id}")
                                            FlatButton(
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          38.0),
                                                  side: BorderSide(
                                                    color: selectedOptions
                                                            .contains(item.id)
                                                        ? colors.orange
                                                        : colors.ggrey,
                                                  ),
                                                ),
                                                color: colors.white,
                                                textColor: selectedOptions
                                                        .contains(item.id)
                                                    ? colors.orange
                                                    : colors.black,
                                                onPressed: () {
                                                  setState(() {
                                                    if (!selectedOptions
                                                        .add(item.id)) {
                                                      selectedOptions
                                                          .remove(item.id);
                                                    }
                                                  });
                                                },
                                                onLongPress: () {},
                                                child: Text(item.name,
                                                    style: styles
                                                        .mysmallforgridview)),
                                      );
                                    }).toList()),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                  child: PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (BuildContext context) {
                                      return choices.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
            // Align(
            //   alignment: Alignment.center,
            //   child: Container(
            //     child: Icon(
            //       FontAwesomeIcons.mapMarkerAlt,
            //       color: colors.blue,
            //       size: 32,
            //     ),
            //   ),
            // ),
          ],
        ));
  }

  Future<void> _animateToUser() async {
    try {
      if (mounted) {
        // final Uint8List markerIcon =
        //     await getBytesFromAsset('assets/images/logo.jpg', 100);
        await location.getLocation().then((LocationData value) {
          mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 13,
          )));
          // getPositionSubscription =
          //     location.onLocationChanged.listen((LocationData value) {
          //   final Marker marker = Marker(
          //       markerId: MarkerId('current_location'),
          //       position: LatLng(value.latitude, value.longitude),
          //       icon: BitmapDescriptor.fromBytes(markerIcon),
          //       infoWindow: InfoWindow(title: trans(context, "your_location")));
          //   _addMarker(marker);
          // });
          setState(() {
            lat = value.latitude;
            long = value.longitude;
          });
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
