import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/locations.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/providers/salesProvider.dart';
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
  PagewiseLoadController<dynamic> pagewiseLocationController;

  Future<List<LocationsData>> getAddressData(int page) async {
    final dynamic response =
        await dio.get<dynamic>("locations", queryParameters: <String, dynamic>{
      'page': page + 1,
    });
    locations = Locations.fromJson(response.data);
    return locations.data;
  }

  void saveLocation(String address, double lat, double long) {
    dio.post<dynamic>("locations", data: <String, dynamic>{
      'address': address ?? "Unknown",
      'latitude': lat,
      'longitude': long
    });
  }

  @override
  void initState() {
    super.initState();
    currentAddress = getIt<Auth>().address;

    lat = getIt<HOMEMAProvider>().lat.toString();

    long = getIt<HOMEMAProvider>().long.toString();

    pagewiseLocationController = PagewiseLoadController<dynamic>(
        pageSize: 15,
        pageFuture: (int pageIndex) async {
          return getAddressData(pageIndex);
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    shadowColor: colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                  },
                )),
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
                  return FadeIn(
                      child: AddressItem(
                          actions: actions,
                          locationData: entry as LocationsData));
                },
                noItemsFoundBuilder: (BuildContext context) {
                  return Text(trans(context, "nothing_to_show"));
                },
                pageLoadController: pagewiseLocationController,
              ),
            ),
          ]),
        ));
  }
}

class AddressItem extends StatelessWidget {
  const AddressItem({Key key, this.actions, this.locationData})
      : super(key: key);
  final List<Widget> actions;
  final LocationsData locationData;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: actions,
      secondaryActions: actions,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        child: Card(
          child: InkWell(
            onTap: () {},
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                if (getIt<MerchantProvider>().pagewiseBranchesController !=
                    null) {
                  getIt<MerchantProvider>().pagewiseBranchesController.reset();
                }

                if (getIt<SalesProvider>().pagewiseHomeSalesController !=
                    null) {
                  getIt<SalesProvider>().pagewiseHomeSalesController.reset();
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
