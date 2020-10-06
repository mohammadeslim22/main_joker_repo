import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/locations.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joker/util/data.dart';
import 'package:joker/providers/locationProvider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/merchantsProvider.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key key}) : super(key: key);

  @override
  AddressListState createState() => AddressListState();
}

class AddressListState extends State<AddressList> {
  Locations locations;
  String currentAddress;
  String lat;
  String long;

  int currentId;
  List<Widget> actions = <Widget>[
    IconSlideAction(
      caption: 'Delete',
      color: colors.red,
      icon: Icons.delete,
      onTap: () {},
    ),
  ];
  @override
  void initState() {
    super.initState();
    data.getData("address").then((String value) {
      setState(() {
        currentAddress = value;
      });
    });
    data.getData("lat").then((String value) {
      setState(() {
        lat = value;
      });
    });
    data.getData("long").then((String value) {
      setState(() {
        long = value;
      });
    });
    getIt<LocationProvider>().pagewiseLocationController =
        PagewiseLoadController<dynamic>(
            pageSize: 15,
            pageFuture: (int pageIndex) async {
              return getIt<LocationProvider>().getAddressData(
                pageIndex,
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(trans(context, 'address_List'), style: styles.appBars),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  "assets/images/address.png",
                  height: 130,
                  width: 130,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("current address:\n$currentAddress",
                                style: styles.underHeadblack),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("lat: $lat" ?? "0.0", style: styles.mylight),
                          Text("long: $long" ?? "0.0", style: styles.mylight)
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              child: RaisedButton(
                  color: colors.jokerBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(trans(context, 'add_address'),
                          style: styles.underHeadwhite),
                      Icon(
                        Icons.add_circle_outline,
                        color: colors.white,
                      )
                    ],
                  ),
                  onPressed: () async {
                    String lat;
                    String long;
                    lat = await data.getData("lat");
                    long = await data.getData("long");

                    await Navigator.pushNamed(context, '/AutoLocate',
                        arguments: <String, dynamic>{
                          "lat": double.parse(lat) ?? 10.176,
                          "long": double.parse(long) ?? 51.6565,
                          "choice": 2
                        });
                  }),
            ),
            Expanded(
              child: PagewiseListView<dynamic>(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                loadingBuilder: (BuildContext context) {
                  return const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  ));
                },
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemBuilder: (BuildContext context, dynamic entry, int index) {
                  return FadeIn(child: showItem(entry as LocationsData));
                },
                noItemsFoundBuilder: (BuildContext context) {
                  return Text(trans(context, "noting_to_show"));
                },
                pageLoadController:
                    getIt<LocationProvider>().pagewiseLocationController,
              ),
            ),
          ]),
        ));
  }

  Widget showItem(LocationsData locationData) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: actions,
      secondaryActions: actions,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        child: Card(
          child: InkWell(
            onTap: () {
              setState(() {
                currentId = locationData.id;
              });
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              selected: locationData.id == currentId,
              title: Text(locationData.address, style: styles.underHeadblack),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                      "${trans(context, 'latitude')}  ${locationData.latitude.toStringAsFixed(3)}"),
                  Text(
                      "${trans(context, 'longitue')}   ${locationData.longitude.toStringAsFixed(3)}"),
                ],
              ),
              onTap: () {
                setState(() {
                  config.lat = locationData.latitude;
                  config.long = locationData.longitude;
                  currentId = locationData.id;
                });
                if (getIt<MerchantProvider>().pagewiseBranchesController !=
                    null){
                      getIt<MerchantProvider>().pagewiseBranchesController.reset();
                    }
                  
                if (getIt<SalesProvider>().pagewiseSalesController != null){
                   getIt<SalesProvider>().pagewiseSalesController.reset();
                }
                 
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
