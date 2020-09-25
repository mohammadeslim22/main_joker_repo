import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
import "package:flutter/cupertino.dart";

class LoadWhereToGo extends StatelessWidget {
  const LoadWhereToGo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      return !getIt<HOMEMAProvider>().specesLoaded
          ? FutureBuilder<dynamic>(
              future: getIt<HOMEMAProvider>().getSpecializationsData(),
              builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const WhereToGo();
                } else {
                  return Container(
                      color: colors.white,
                      child: const CupertinoActivityIndicator());
                }
              },
            )
          : const WhereToGo();
    }
  }
}

class WhereToGo extends StatefulWidget {
  const WhereToGo({Key key}) : super(key: key);

  @override
  _WhereToGoState createState() => _WhereToGoState();
}

class _WhereToGoState extends State<WhereToGo> {
  GlobalKey<ScaffoldState> _scaffoldkey;
  PersistentBottomSheetController<dynamic> errorController;

  @override
  void initState() {
    super.initState();
    _scaffoldkey = GlobalKey<ScaffoldState>();
    distributeOnList(getIt<HOMEMAProvider>().specializations);
  }

  List<Widget> listviewWidgets = <Widget>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: NestedScrollView(
        physics: const ScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              expandedHeight: 215,
              elevation: 0,
              backgroundColor: colors.trans,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                background: InkWell(
                  onTap: () {},
                  child: Stack(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 240,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.horizontal,
                          onPageChanged:
                              (int index, CarouselPageChangedReason reason) {},
                          pageViewKey:
                              const PageStorageKey<dynamic>('carousel_slider'),
                        ),
                        items: <int>[1, 2, 3].map((int image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://thumbs.dreamstime.com/z/photo-beatch-photo-beatch-196011893.jpg"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(trans(context, 'where_do_u_want_to_go'),
                              style: styles.wheretogo),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: Consumer<HOMEMAProvider>(builder:
            (BuildContext context, HOMEMAProvider value, Widget child) {
          return Column(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                children: listviewWidgets,
              ),
              RaisedButton(
                color: !value.specSelected ? colors.ggrey : colors.white,
                onPressed: () {
                  value.specSelected
                      ? Navigator.pushNamed(context, "/Home",
                          arguments: <String, dynamic>{
                              "salesDataFilter": false,
                              "FilterData": null
                            })
                      : print("");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("${trans(context, 'open_in_list')}"),
                    Icon(Icons.list, color: colors.blue)
                  ],
                ),
              ),
              RaisedButton(
                color: !value.specSelected ? colors.ggrey : colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("${trans(context, 'show_on_map')}"),
                    Icon(
                      Icons.map,
                      color: colors.blue,
                    ),
                  ],
                ),
                onPressed: () {
                  value.specSelected
                      ? Navigator.pushNamed(context, "/MapAsHome",
                          arguments: <String, dynamic>{
                              "home_map_lat": config.lat ?? 0.0,
                              "home_map_long": config.long ?? 0.0
                            })
                      : print("");
                },
              )
            ],
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: CircleAvatar(
        backgroundColor: colors.white,
        radius: 24,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.add),
          color: colors.yellow,
          onPressed: () {},
        ),
      ),
    );
  }

  void distributeOnList(List<Specializations> specializations) {
    for (int i = 0; i < specializations.length; i += 2) {
      listviewWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          specButton(specializations[i]),
          specButton(specializations[i + 1])
        ],
      ));
      // listviewWidgets.add(const Divider(thickness: 1));
      if (i == specializations.length - 3) {
        listviewWidgets
            .add(specButton(specializations[specializations.length - 1]));

        break;
      }
      listviewWidgets.add(const SizedBox(height: 40));
    }
  }

  Widget specButton(Specializations item) {
    return Consumer<HOMEMAProvider>(
      builder: (BuildContext context, HOMEMAProvider value, Widget child) {
        return Expanded(
          child: FlatButton(
            color: value.selectedSpecialize == item.id
                ? colors.ggrey
                : colors.white,
            shape:
                RoundedRectangleBorder(side: BorderSide(color: colors.ggrey)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(item.name, style: styles.maingridview),
                const SizedBox(height: 40),
                if (item.id % 2 == 1)
                  const Icon(Icons.restaurant)
                else
                  const Icon(Icons.local_cafe),
                const SizedBox(height: 10),
              ],
            ),
            onPressed: () {
              getIt<HOMEMAProvider>().setSlelectedSpec(item.id);
              setState(() {
                if (value.selectedSpecialize != null) {
                  value.specSelected = true;
                } else {
                  value.specSelected = false;
                }
              });
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
      },
    );
  }
}
