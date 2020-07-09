import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import '../../localization/trans.dart';
import '../../constants/colors.dart';
import 'package:joker/util/data.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/dio.dart';

class MyInnerDrawer extends StatefulWidget {
  const MyInnerDrawer({this.scaffold, this.drawerKey});

  final Widget scaffold;

  final GlobalKey<InnerDrawerState> drawerKey;
  @override
  _MyInnerDrawerState createState() => _MyInnerDrawerState();
}

class _MyInnerDrawerState extends State<MyInnerDrawer> {
  void toggle() {
    widget.drawerKey.currentState.toggle(
        // direction is optional
        // if not set, the last direction will be used
        //InnerDrawerDirection.start OR InnerDrawerDirection.end
        // direction: InnerDrawerDirection.end,
        );
  }

  String username = ".";
  @override
  void initState() {
    super.initState();
    if (config.username == null) {
      data.getData("username").then((String value) {
        setState(() {
          username = value ?? "";
        });
      });
    } else {
      username = config.username;
    }
    print(config.profileUrl);
    data.getData("profile_pic").then((String value) {
      print("profile drawer pic:   $value");
      setState(() {
        config.profileUrl = value;
      });
      if (value.isEmpty) {
        print("error here ?");
        dio.get<dynamic>("user").then((Response<dynamic> value) {
          print(value.data['data']['name'].toString());
          setState(() {
            username= value.data['data']['name'].toString();
            config.username = value.data['data']['name'].toString();
            config.profileUrl = value.data['data']['image'].toString().trim();
          });

          data.setData("profile_pic", value.data['data']['image'].toString());
          data.setData("username", value.data['data']['name'].toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final Scaffold menu = Scaffold(
      backgroundColor: colors.grey,
      body: ListView(
        padding:
            const EdgeInsets.only(top: 26, left: 16, bottom: 16, right: 16),
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 4),
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned.directional(
                          top: 10,
                          start: 60,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 60),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(username, style: styles.underHead),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          textDirection:
                              isRTL ? TextDirection.rtl : TextDirection.ltr),
                      Positioned(
                          child: CircleAvatar(
                        maxRadius: 40,
                        minRadius: 30,
                        child: //Image.asset("assets/images/profile_placeholder.jpg")

                            CachedNetworkImage(
                          placeholderFadeInDuration:
                              const Duration(milliseconds: 300),
                          imageUrl: config.profileUrl.trim() ?? "",
                          imageBuilder: (BuildContext context,
                                  ImageProvider imageProvider) =>
                              Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.colorBurn)),
                            ),
                          ),
                          placeholder: (BuildContext context, String url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (BuildContext context, String url,
                                  dynamic error) =>
                              Icon(Icons.error),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Row(
                  children: <Widget>[
                    Text("${trans(context, 'notifications')}"),
                    Badge(
                      position: BadgePosition.topRight(top: 16, right: 10),
                      badgeContent: Container(
                        margin: const EdgeInsets.only(left: 24, right: 24),
                        padding: const EdgeInsets.all(4),
                        child: const Text("10"),
                      ),
                      badgeColor: colors.yellow,
                    ),
                  ],
                ),
                leading: SvgPicture.asset("assets/images/notifications.svg"),
                onTap: () {
                  Navigator.pushNamed(context, "/Notifications");
                  toggle();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'account')}"),
                leading: SvgPicture.asset("assets/images/account.svg"),
                onTap: () {
                  Navigator.pushNamed(context, "/Profile");
                  toggle();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'membership')}"),
                leading: SvgPicture.asset("assets/images/vip.svg"),
                onTap: () {
                  Navigator.pushNamed(
                    context, "/Membership",
                    // arguments: <String, List<MemberShip>>{
                    //   "membershipsData": MemberShip.membershipsData
                    // }
                  );
                  toggle();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'fav')}"),
                leading: CircleAvatar(
                  backgroundColor: colors.white,
                  radius: 22,
                  child: SvgPicture.asset(
                    'assets/images/loveicon.svg',
                    height: 20,
                    width: 20,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/Fav");
                  toggle();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'settings')}"),
                leading: SvgPicture.asset("assets/images/settings.svg"),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                  toggle();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'privacy')}"),
                leading: SvgPicture.asset("assets/images/privacy.svg"),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/AboutUs', (_) => false);
                  toggle();
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'support')}"),
                leading: SvgPicture.asset("assets/images/support.svg"),
                onTap: () {
                  Navigator.pushNamed(context, '/ContactUs');
                  toggle();
                },
              ),
            ],
          ),
          const SizedBox(height: 36.0),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            title: Text("${trans(context, 'logout')}"),
            leading: SvgPicture.asset("assets/images/logout.svg"),
            onTap: () {
              data.setData('authorization', null);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (_) => false);
            },
          ),
        ],
      ),
    );
    return InnerDrawer(
      key: widget.drawerKey,
      onTapClose: false, // default false
      swipe: true, // default true
      colorTransition: Colors.black, // default Color.black54
      tapScaffoldEnabled: true,

      //When setting the vertical offset, be sure to use only top or bottom
      offset:
          const IDOffset.only(top: 0.0, bottom: 0.08, left: 0.2, right: 0.2),

      // set the offset in both directions
      scale: const IDOffset.horizontal(0.65),
      // scale: const IDOffset.only(left: 0.8, right: 0.8),

      proportionalChildArea: false,
      borderRadius: 16,
      leftAnimationType: InnerDrawerAnimation.static, // default static
      rightAnimationType: InnerDrawerAnimation.quadratic,
      backgroundColor:
          colors.grey, // default  Theme.of(context).backgroundColor

      // TODO(ahmed): no need NOW
      //when a pointer that is in contact with the screen and moves to the right or left
      /* onDragUpdate: (double val, InnerDrawerDirection direction) {
              // print(val);
              // check if the swipe is to the right or to the left
              print(direction == InnerDrawerDirection.start);
            }, */
      // TODO(ahmed): no need NOW for callback
      // innerDrawerCallback: (bool a) => print("----- $a"),
      // return  true (open) or false (close)

      leftChild: menu,

      // required if rightChild is not set
      // rightChild: Container(), // required if leftChild is not set

      // Note: use "automaticallyImplyLeading: false" if you do not personalize "leading" of Bar
      scaffold: widget.scaffold,
    );
  }
}
