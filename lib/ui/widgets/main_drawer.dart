import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/ui/view_models/notifications_modle.dart';
import 'package:joker/util/service_locator.dart';
import 'package:package_info/package_info.dart';

import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int numberOfNotifications = 0;
  @override
  void initState() {
    super.initState();

    // if (getIt<Auth>().isAuthintecated) {
    //   getIt<NotificationsModel>().pagewiseNotificationsController =
    //       PagewiseLoadController<dynamic>(
    //           pageSize: 15,
    //           pageFuture: (int pageIndex) async {
    //             return getIt<NotificationsModel>().getNotifications(pageIndex);
    //           });
    // }
    // getIt<SalesProvider>().pagewiseFavSalesController =
    //     PagewiseLoadController<dynamic>(
    //         pageSize: 10,
    //         pageFuture: (int pageIndex) async {
    //           return getIt<SalesProvider>().getFavoritData(pageIndex);
    //         });
    // getIt<MerchantProvider>().pagewiseFavBranchesController =
    //     PagewiseLoadController<dynamic>(
    //         pageSize: 10,
    //         pageFuture: (int pageIndex) async {
    //           return getIt<MerchantProvider>().getFavoritData(pageIndex);
    //         });
    numberOfNotifications = getIt<NotificationsModel>().unredNotifications ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
        backgroundColor: colors.white,
        body: ChangeNotifierProvider<Auth>.value(
            value: getIt<Auth>(),
            child: Consumer<Auth>(
                builder: (BuildContext context, Auth modle, Widget child) =>
                    ListView(
                      padding: const EdgeInsets.only(
                          top: 32, left: 16, bottom: 16, right: 16),
                      shrinkWrap: true,
                      children: <Widget>[
                        MenuContent(
                            isRTL: isRTL,
                            modle: modle,
                            numberOfNotifications: numberOfNotifications),
                        const SizedBox(height: 8),
                        Visibility(
                          visible: modle.isAuthintecated,
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(left: 0),
                            title: Text("${trans(context, 'logout')}"),
                            leading:
                                Image.asset("assets/images/menu_logout.png"),
                            onTap: () async {
                              await modle.signOut(context);
                            },
                          ),
                        ),
                      ],
                    ))));
  }
}

class MenuContent extends StatelessWidget {
  const MenuContent(
      {Key key, this.isRTL, this.modle, this.numberOfNotifications})
      : super(key: key);
  final bool isRTL;
  final Auth modle;
  final int numberOfNotifications;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        modle.userPicture.replaceFirst('http:', 'https:') ??
                            config.profileUrl,
                    imageBuilder:
                        (BuildContext context, ImageProvider imageProvider) =>
                            Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (BuildContext context, String url) =>
                        const CircularProgressIndicator(),
                    errorWidget:
                        (BuildContext context, String url, dynamic error) =>
                            const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  radius: 30,
                  onTap: () async {
                    // if (config.loggedin) {
                    if (modle.isAuthintecated) {
                      Navigator.popAndPushNamed(context, "/Profile");
                    } else {
                      getIt<NavigationService>().navigateTo('/login', null);
                    }
                  },
                  child: Text(
                      modle.isAuthintecated
                          ? modle.username
                          : trans(context, "login_or_sign_up") ??
                              config.username,
                      style: styles.username),
                ),
              ],
            ),
            Align(
              alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  // goToMap(context);
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
            Navigator.popAndPushNamed(context, '/Home');
          },
        ),
        const SizedBox(height: 8),
        ListTile(
          enabled: modle.isAuthintecated,
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
        ListTile(
          enabled: modle.isAuthintecated,
          contentPadding: const EdgeInsets.only(left: 0),
          title: Text("${trans(context, 'fav')}"),
          leading: Image.asset("assets/images/menu_favorite.png"),
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
          onTap: () async {
            final PackageInfo packageInfo = await PackageInfo.fromPlatform();
            final String appName = packageInfo.appName;

            final String version = packageInfo.version;

            Navigator.pushNamed(context, '/AboutUs',
                arguments: <String, String>{
                  "appName": appName,
                  "appVersion": version
                });
          },
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 0),
          title: Text("${trans(context, 'support')}"),
          leading: Image.asset("assets/images/menu_support.png"),
          onTap: () {
            Navigator.pushNamed(context, '/ContactUs');
          },
        ),
      ],
    );
  }
}
