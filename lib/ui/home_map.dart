import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/map_branches.dart';
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
  Coordinates coordinates;
  List<Address> addresses;
  Address address;
  GlobalKey<ScaffoldState> _scaffoldkey;

  @override
  void initState() {
    super.initState();
    lat = widget.lat;
    long = widget.long;
    _scaffoldkey = GlobalKey<ScaffoldState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      choices = <String>[trans(context, "home"), trans(context, "exit")];

      getIt<HOMEMAProvider>().getBranchesData(_scaffoldkey, lat, long);
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
  Set<int> selectedOptions = <int>{};

  @override
  Widget build(BuildContext context) {
    final HOMEMAProvider mapProv = Provider.of<HOMEMAProvider>(context);

    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Stack(
          children: <Widget>[
            Scaffold(
                key: _scaffoldkey,
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
                            permissionGranted = await location.hasPermission();

                            if (permissionGranted == PermissionStatus.denied) {
                            } else {
                              if (!serviceEnabled) {
                              } else {
                                _animateToUser();
                              }
                            }
                            await Future<void>.delayed(
                                const Duration(microseconds: 2000));
                            mapController = controller;

                            controller
                                .showMarkerInfoWindow(value.markers.keys.last);
                          },
                          onTap: (LatLng ll) {
                            print(ll);
                            getIt<HOMEMAProvider>()
                                .showHorizentalListOrHideIt(false);
                          },
                          padding: const EdgeInsets.only(bottom: 60),
                          mapType: MapType.normal,
                          markers: Set<Marker>.of(mapProv.markers.values),
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
                              getIt<HOMEMAProvider>()
                                  .getBranchesData(_scaffoldkey, lat, long);
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
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black.withOpacity(.55),
                            padding: const EdgeInsets.fromLTRB(0, 28, 0, 12),
                            height: 80,
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
                                        child: FlatButton(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(38.0),
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
                                                style:
                                                    styles.mysmallforgridview)),
                                      );
                                    }).toList()),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                  child: PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert,
                                        color: colors.white),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (BuildContext context) {
                                      return choices.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: FlatButton(
                                              onPressed: () {},
                                              child: Text(choice)),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (mapProv.horizentalListOn)
                          Positioned(
                              bottom: 40,
                              child: Container(
                                height: 140,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  children: value.branches.mapBranches
                                      .map((MapBranch e) {
                                    return listHorizentalCard(e);
                                  }).toList(),
                                ),
                              ))
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
          ],
        ));
  }

  Future<void> _animateToUser() async {
    try {
      if (mounted) {
        await location.getLocation().then((LocationData value) {
          mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 13,
          )));

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

  Widget listHorizentalCard(MapBranch e) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            mapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(e.latitude, e.longitude),
              zoom: 13,
            )));
            lat = e.latitude;
            long = e.longitude;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(e.merchant.logo),
                        fit: BoxFit.cover),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      e.merchant.name,
                      textAlign: TextAlign.center,
                      style: styles.underHead,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: e.twoSales.map((TwoSales e) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(e.name, textAlign: TextAlign.start),
                                const SizedBox(width: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      e.newPrice,
                                      style: styles.redstyleForminiSaleScreen,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      e.oldPrice,
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    FlatButton(
                        onPressed: () {},
                        child: Text(trans(context, "show_more")))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
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
