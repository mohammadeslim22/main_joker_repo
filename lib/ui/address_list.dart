import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/locations.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/ui/widgets/fadein.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:joker/util/data.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key key}) : super(key: key);

  @override
  AddressListState createState() => AddressListState();
}

class AddressListState extends State<AddressList> {
  Locations locations;
  Future<List<LocationsData>> getAddressData(int page) async {
    final dynamic response =
        await dio.get<dynamic>("locations", queryParameters: <String, dynamic>{
      'page': page + 1,
    });
    locations = Locations.fromJson(response.data);
    return locations.data;
  }

  String currentAddress;
  String lat;
  String long;

  int currentId;
  List<Widget> actions = <Widget>[
    IconSlideAction(
      caption: 'Delete',
      color: Colors.red,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(trans(context, 'address_List')),
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
                  color: colors.orange,
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
                        arguments: <String, double>{
                          "lat": double.parse(lat) ?? 10.176,
                          "long": double.parse(long) ?? 51.6565
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
                  pageSize: 10,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemBuilder:
                      (BuildContext context, dynamic entry, int index) {
                    return FadeIn(child: showItem(entry as LocationsData));
                  },
                  noItemsFoundBuilder: (BuildContext context) {
                    return Text(trans(context, "noting_to_show"));
                  },
                  pageFuture: (int pageIndex) {
                    return getAddressData(pageIndex);
                  }),
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
                  currentId = locationData.id;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class AddressListItem extends StatefulWidget {
//   const AddressListItem({Key key, this.locationData, this.currentId = 0})
//       : super(key: key);
//   final LocationsData locationData;
//   final int currentId;
//   @override
//   AddressListItemState createState() => AddressListItemState();
// }

// class AddressListItemState extends State<AddressListItem> {
//   LocationsData locationData;
//   @override
//   void initState() {
//     super.initState();
//     locationData = widget.locationData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       actionPane: const SlidableDrawerActionPane(),
//       actionExtentRatio: 0.25,
//       actions: actions,
//       secondaryActions: actions,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 1000),
//         child: Card(
//           child: InkWell(
//               onTap: () {},
//               child: ListTile(
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//                 selected: locationData.id == widget.currentId,
//                 title: Text(locationData.address, style: styles.underHeadblack),
//                 subtitle: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     Text(
//                         "${trans(context, 'latitude')}   ${locationData.latitude.toStringAsFixed(3)}"),
//                     Text(
//                         "${trans(context, 'longitue')}   ${locationData.longitude.toStringAsFixed(3)}"),
//                   ],
//                 ),
//                 onTap: () {
//                   setState(() {});
//                 },
//               )

//               // Container(
//               //   padding:
//               //   child: Column(
//               //     children: <Widget>[
//               //       Text(locationData.address, style: styles.underHeadblack),
//               //       Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //         children: <Widget>[
//               //           Text(
//               //               "${trans(context, 'latitude')}   ${locationData.latitude.toStringAsFixed(3)}"),
//               //           Text(
//               //               "${trans(context, 'longitue')}   ${locationData.longitude.toStringAsFixed(3)}"),
//               //         ],
//               //       )
//               //     ],
//               //   ),
//               // ),
//               ),
//         ),
//       ),
//     );
//   }
// }
