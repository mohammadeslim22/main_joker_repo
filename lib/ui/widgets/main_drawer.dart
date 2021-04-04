import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/service_locator.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int numberOfNotifications;
  @override
  void initState() {
    super.initState();
    if (config.loggedin) {
      getIt<MainProvider>().getNotifications();
    }
    numberOfNotifications = getIt<Auth>().unredNotifications ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      backgroundColor: colors.white,
      body: ListView(
        padding:
            const EdgeInsets.only(top: 32, left: 16, bottom: 16, right: 16),
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 4),
                      CircleAvatar(
                        maxRadius: 40,
                        minRadius: 30,
                        child: CachedNetworkImage(
                          placeholderFadeInDuration:
                              const Duration(milliseconds: 300),
                          imageUrl:
                              getIt<Auth>().userPicture ?? config.profileUrl,
                          imageBuilder: (BuildContext context,
                                  ImageProvider imageProvider) =>
                              Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (BuildContext context, String url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (BuildContext context, String url,
                                  dynamic error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        radius: 30,
                        onTap: () {
                          if (config.loggedin)
                            Navigator.popAndPushNamed(context, "/Profile");
                          else
                            getIt<NavigationService>()
                                .navigateTo('/login', null);
                        },
                        child: Text(getIt<Auth>().username ?? config.username,
                            style: styles.username),
                      ),
                    ],
                  ),
                  Align(
                    alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        goToMap(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          children: <Widget>[
                            Text(trans(context, 'back_to_map')),
                            const SizedBox(width: 16),
                            Icon(Icons.keyboard_return, color: colors.orange)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Row(
                  children: <Widget>[
                    Text("${trans(context, 'home')}"),
                  ],
                ),
                leading: Image.asset("assets/images/menu_home.png"),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/Home',
                      arguments: <String, dynamic>{
                        "salesDataFilter": false,
                        "FilterData": null
                      });
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Row(
                  children: <Widget>[
                    Text("${trans(context, 'notifications')}"),
                    Badge(
                      position: BadgePosition.topStart(top: 16, start: 10),
                      badgeContent: Container(
                          margin: const EdgeInsets.only(left: 24, right: 24),
                          padding: const EdgeInsets.all(4),
                          child: Text(numberOfNotifications.toString())),
                      badgeColor: colors.yellow,
                    ),
                  ],
                ),
                leading: Image.asset("assets/images/menu_notifications.png"),
                onTap: () {
                  Navigator.pushNamed(context, "/Notifications");
                },
              ),
              const SizedBox(height: 8),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 0),
              //   title: Text("${trans(context, 'sale_list')}"),
              //   leading: SvgPicture.asset("assets/images/fave_group.svg"),
              //   onTap: () {
              //     Navigator.pushNamed(context, "/Home");
              //   },
              // ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 0),
              //   title: Text("${trans(context, 'account')}"),
              //   leading: SvgPicture.asset("assets/images/fave_group.svg"),
              //   onTap: () {
              //     Navigator.pushNamed(context, "/Profile");
              //   },
              // ),

              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 0),
              //   title: Text("${trans(context, 'membership')}"),
              //   leading: Image.asset("assets/images/menu_membership.png"),

              //   // SvgPicture.asset("assets/images/vip.svg"),
              //   onTap: () {
              //     Navigator.pushNamed(context, "/Membership");
              //   },
              // ),
              // const SizedBox(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'fav')}"),
                leading: Image.asset("assets/images/menu_favorite.png"),
                // CircleAvatar(
                //   backgroundColor: colors.white,
                //   radius: 22,
                //   child: SvgPicture.asset('assets/images/loveicon.svg',
                //       height: 20, width: 20),
                // ),
                onTap: () {
                  Navigator.pushNamed(context, "/Fav");
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'settings')}"),
                leading: Image.asset("assets/images/menu_settings.png"),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'privacy')}"),
                leading: Image.asset("assets/images/menu_privacy.png"),
                // SvgPicture.asset("assets/images/privecy_group.svg"),
                onTap: () {
                  Navigator.pushNamed(context, '/AboutUs');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text("${trans(context, 'support')}"),
                leading: Image.asset("assets/images/menu_support.png"),
                // SvgPicture.asset("assets/images/support_group.svg"),
                onTap: () {
                  Navigator.pushNamed(context, '/ContactUs');
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          // const SizedBox(height: 36.0),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            title: Text("${trans(context, 'logout')}"),
            leading: Image.asset("assets/images/menu_logout.png"),
            // SvgPicture.asset("assets/images/logout.svg"),
            onTap: () async {
              await getIt<Auth>().signOut();
              // data.setData('authorization', "");
              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/login', (_) => false);
            },
          ),
        ],
      ),
    );
  }
}
