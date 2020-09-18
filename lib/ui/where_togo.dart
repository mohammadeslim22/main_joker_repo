import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:provider/provider.dart';

class WhereToGo extends StatefulWidget {
  const WhereToGo({Key key}) : super(key: key);

  @override
  _WhereToGoState createState() => _WhereToGoState();
}

class _WhereToGoState extends State<WhereToGo> {
  GlobalKey<ScaffoldState> _scaffoldkey;
  PersistentBottomSheetController<dynamic> _errorController;
  @override
  void initState() {
    super.initState();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    getIt<HOMEMAProvider>().getSpecializationsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: Column(
          children: <Widget>[
            const SizedBox(height: 60),
            Text(trans(context, 'where_do_u_want_to_go'),
                style: styles.appBars),
            const SizedBox(height: 40),
            Consumer<HOMEMAProvider>(builder:
                (BuildContext context, HOMEMAProvider value, Widget child) {
              return GridView.count(
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  primary: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  addRepaintBoundaries: true,
                  children: getIt<HOMEMAProvider>()
                      .specializations
                      .map((Specializations item) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: colors.jokerBlue),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16))),
                      child: FlatButton(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            Text(item.name, style: styles.maingridview),
                            Expanded(
                                child: item.id % 2 == 1
                                    ? Image.asset("assets/images/pizza.jpg")
                                    : Image.asset("assets/images/cafe.jpg")

                                // CachedNetworkImage(
                                //     fit: BoxFit.cover,
                                //     imageUrl:
                                //         "https://pixabay.com/photos/pizza-food-italian-baked-cheese-3007395")

                                )
                          ],
                        ),
                        onPressed: () {
                          getIt<HOMEMAProvider>().setSlelectedSpec(item.id);
                          _errorController = _scaffoldkey.currentState
                              .showBottomSheet<dynamic>(
                                  (BuildContext context) =>
                                      locationBottomSheet());
                        },
                        onLongPress: () {
                          Fluttertoast.showToast(
                              msg: item.name,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[300],
                              textColor: colors.jokerBlue,
                              fontSize: 16.0);
                        },
                      ),
                    );
                  }).toList());
            })
          ],
        ));
  }

  Widget locationBottomSheet() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24)),
        )),
      ),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text("${trans(context, 'open_in_list')}"),
        trailing: Icon(
          Icons.list,
          color: colors.blue,
        ),
        onTap: () async {
          Navigator.pushNamed(context, "/Home", arguments: <String, dynamic>{
            "salesDataFilter": false,
            "FilterData": null
          });
        },
      ),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text("${trans(context, 'show_on_map')}"),
        trailing: Icon(
          Icons.map,
          color: colors.blue,
        ),
        onTap: () async {
          Navigator.pushNamed(context, "/MapAsHome",
              arguments: <String, dynamic>{
                "home_map_lat": config.lat ?? 0.0,
                "home_map_long": config.long ?? 0.0
              });
        },
      ),
      const SizedBox(height: 12),
    ]);
  }
}
