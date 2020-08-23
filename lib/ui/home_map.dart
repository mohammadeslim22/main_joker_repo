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
import 'package:joker/providers/map_provider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:joker/models/specializations.dart';
import '../constants/styles.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/providers/auth.dart';

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
  List<Choic> choices;
  Coordinates coordinates;
  List<Address> addresses;
  Address address;
  GlobalKey<ScaffoldState> _scaffoldkey;
  int specId;
  @override
  void initState() {
    super.initState();
    lat = widget.lat;
    long = widget.long;
    _scaffoldkey = GlobalKey<ScaffoldState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      choices = <Choic>[
        Choic(trans(context, "home"), 0),
        Choic(trans(context, "logout"), 1)
      ];

      getIt<HOMEMAProvider>().getBranchesData(_scaffoldkey, lat, long, specId);
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App'),
            actionsOverflowButtonSpacing: 50,
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => SystemChannels.platform
                    .invokeMethod<dynamic>("SystemNavigator.pop"),
                //  exit(0),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Set<int> selectedOptions = <int>{};

  @override
  Widget build(BuildContext context) {
    final HOMEMAProvider mapProv = Provider.of<HOMEMAProvider>(context);

    return WillPopScope(
        onWillPop: _onWillPop,
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
                            print("specId  :$specId");
                            setState(() {
                              lat = pos.target.latitude;
                              long = pos.target.longitude;
                            });
                          },
                          onCameraIdle: () {
                            setState(() {
                              getIt<HOMEMAProvider>().getBranchesData(
                                  _scaffoldkey, lat, long, specId);
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
                                                    ? colors.jokerBlue
                                                    : colors.ggrey,
                                              ),
                                            ),
                                            color: colors.white,
                                            textColor: selectedOptions
                                                    .contains(item.id)
                                                ? colors.jokerBlue
                                                : colors.black,
                                            onPressed: () {
                                              setState(() {
                                                if (!selectedOptions
                                                    .add(item.id)) {
                                                  selectedOptions
                                                      .remove(item.id);
                                                  specId = null;
                                                } else {
                                                  selectedOptions.clear();
                                                  specId = item.id;
                                                  selectedOptions.add(item.id);
                                                }
                                                getIt<HOMEMAProvider>()
                                                    .showHorizentalListOrHideIt(
                                                        false);
                                                getIt<HOMEMAProvider>()
                                                    .getBranchesData(
                                                        _scaffoldkey,
                                                        lat,
                                                        long,
                                                        specId);
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
                                  child: PopupMenuButton<Choic>(
                                    onSelected: (Choic value) {
                                      if (value.id == 0) {
                                        Navigator.pushNamed(context, "/Home",
                                            arguments: <String, dynamic>{
                                              "salesDataFilter": false,
                                              "FilterData": null
                                            });
                                      } else {
                                     getIt<Auth>().signOut();
                                      }
                                    },
                                    icon: Icon(Icons.more_vert,
                                        color: colors.white),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (BuildContext context) {
                                      return choices.map((Choic choice) {
                                        return PopupMenuItem<Choic>(
                                          value: choice,
                                          child: Text(choice.name),
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
                                height: 145,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  children: value.inFocusBranch.twoSales
                                      .map((TwoSales e) {
                                    return listHorizentalCard(
                                        value.inFocusBranch, e);
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

  Widget listHorizentalCard(MapBranch mb, TwoSales e) {
    return Card(
      child: InkWell(
        onTap: () {
          getIt<NavigationService>().navigateToNamed(
            "/MerchantDetails",
            <String, dynamic>{"merchantId": mb.merchant.id, "branchId": mb.id},
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  height: 65,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(e.mainImage),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: <Widget>[
                      Text(mb.name,
                          textAlign: TextAlign.center, style: styles.underHead),
                      Container(
                        color: colors.white,
                        child: Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${e.name}'),
                              const SizedBox(width: 80),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    e.newPrice ?? "",
                                    style: styles.redstyleForSaleScreen,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    e.oldPrice,
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    trans(context, 'starting_date'),
                                    style: styles.mysmalllight,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(e.startAt, style: styles.mystyle)
                                ],
                              ),
                              const SizedBox(width: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    trans(context, 'end_date'),
                                    style: styles.mysmalllight,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(e.endAt, style: styles.mystyle)
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                      FlatButton(
                          onPressed: () {
                            getIt<NavigationService>().navigateToNamed(
                              "/MerchantDetails",
                              <String, dynamic>{
                                "merchantId": mb.merchant.id,
                                "branchId": mb.id
                              },
                            );
                          },
                          child: Text(trans(context, "show_more")))
                    ],
                  ),
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

class Choic {
  Choic(this.name, this.id);

  String name;
  int id;
}
