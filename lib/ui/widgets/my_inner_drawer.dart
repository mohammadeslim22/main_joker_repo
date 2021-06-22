import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/ui/view_models/notifications_modle.dart';
import 'package:joker/util/functions.dart';
// import 'package:joker/scoped_models/notifications_model.dart';
// import 'package:joker/scoped_models/user_model.dart';
// import 'package:joker/ui/view_models/registration_model.dart';
import 'package:package_info/package_info.dart';
import '../../localization/trans.dart';
import '../../constants/colors.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/util/service_locator.dart';
import 'package:provider/provider.dart';
// import 'package:scoped_model/scoped_model.dart';

class MyInnerDrawer extends StatefulWidget {
  const MyInnerDrawer({this.scaffold, this.drawerKey});

  final Widget scaffold;

  final GlobalKey<InnerDrawerState> drawerKey;
  @override
  _MyInnerDrawerState createState() => _MyInnerDrawerState();
}

class _MyInnerDrawerState extends State<MyInnerDrawer> {
  int numberOfNotifications = 0;
  void toggle() {
    widget.drawerKey.currentState.toggle(
        // direction is optional
        // if not set, the last direction will be used
        //InnerDrawerDirection.start OR InnerDrawerDirection.end
        // direction: InnerDrawerDirection.end,
        );
  }

  @override
  void initState() {
    super.initState();
    // if (config.loggedin) {
    // if (getIt<Auth>().isAuthintecated) {
    //    getIt<NotificationsModel>().getNotifications();
    // }
    numberOfNotifications = getIt<NotificationsModel>().unredNotifications ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final Scaffold menu = Scaffold(
        backgroundColor: colors.grey,
        body: ChangeNotifierProvider<Auth>.value(
            value: getIt<Auth>(),
            child: Consumer<Auth>(
                builder: (BuildContext context, Auth modle, Widget child) =>
                    ListView(
                      padding: const EdgeInsets.only(
                          top: 26, left: 16, bottom: 16, right: 16),
                      shrinkWrap: true,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            const SizedBox(height: 16),
                            TopMenu(isRTL: isRTL, modle: modle),
                            const SizedBox(height: 32),
                            ListTile(
                             
                                
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Text("${trans(context, 'back_to_map')}"),
                              leading: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  icon: const Icon(Icons.map_outlined)),
                              onTap: () {
                                goToMap(context);
                                // Navigator.pushNamed(context, "/Profile");
                                toggle();
                              },
                            ),
                            ListTile(
                              enabled: /*config.loggedin*/ modle
                                  .isAuthintecated,
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Row(
                                children: <Widget>[
                                  Text("${trans(context, 'notifications')}"),
                                  Badge(
                                    position: BadgePosition.topStart(
                                        top: 16, start: 10),
                                    badgeContent: Container(
                                      margin: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                          numberOfNotifications.toString()),
                                    ),
                                    badgeColor: colors.yellow,
                                  ),
                                ],
                              ),
                              leading: SvgPicture.asset(
                                  "assets/images/notifications.svg"),
                              onTap: () {
                                Navigator.pushNamed(context, "/Notifications");
                                toggle();
                              },
                            ),
                            ListTile(
                              enabled: /*config.loggedin*/ modle
                                  .isAuthintecated,
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Text("${trans(context, 'account')}"),
                              leading:
                                  SvgPicture.asset("assets/images/account.svg"),
                              onTap: () {
                                Navigator.pushNamed(context, "/Profile");
                                toggle();
                              },
                            ),
                            ListTile(
                              enabled: /*config.loggedin*/ modle
                                  .isAuthintecated,
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Text("${trans(context, 'membership')}"),
                              leading:
                                  SvgPicture.asset("assets/images/vip.svg"),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/Membership",
                                );
                                toggle();
                              },
                            ),
                            ListTile(
                              enabled: /*config.loggedin*/ modle
                                  .isAuthintecated,
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
                              leading: SvgPicture.asset(
                                  "assets/images/settings.svg"),
                              onTap: () {
                                Navigator.pushNamed(context, '/settings');
                                toggle();
                              },
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Text("${trans(context, 'privacy')}"),
                              leading:
                                  SvgPicture.asset("assets/images/privacy.svg"),
                              onTap: () async {
                                final PackageInfo packageInfo =
                                    await PackageInfo.fromPlatform();
                                final String appName = packageInfo.appName;

                                final String version = packageInfo.version;

                                Navigator.pushNamed(context, '/AboutUs',
                                    arguments: <String, String>{
                                      "appName": appName,
                                      "appVersion": version
                                    });

                                toggle();
                              },
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Text("${trans(context, 'support')}"),
                              leading:
                                  SvgPicture.asset("assets/images/support.svg"),
                              onTap: () {
                                Navigator.pushNamed(context, '/ContactUs');
                                toggle();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 36.0),
                        Visibility(
                            visible: modle.isAuthintecated,
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Text("${trans(context, 'logout')}"),
                              leading:
                                  SvgPicture.asset("assets/images/logout.svg"),
                              onTap: () async {
                                await modle.signOut(context);
                                // data.setData('authorization', "");
                                // Navigator.pushNamedAndRemoveUntil(
                                //     context, '/login', (_) => false);
                              },
                            )),
                      ],
                    ))));
    return InnerDrawer(
      key: widget.drawerKey,
      onTapClose: false, // default false
      swipe: true, // default true
      colorTransitionScaffold: colors.black,
      // colorTransition: // default Color.black54
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
      backgroundDecoration: BoxDecoration(
        color: colors.grey,
      ),
      leftChild: menu,
      scaffold: widget.scaffold,
    );
  }
}

class TopMenu extends StatelessWidget {
  const TopMenu({Key key, this.isRTL, this.modle}) : super(key: key);
  final bool isRTL;
  final Auth modle;
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Stack(
          alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
          children: <Widget>[
            Align(
                alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 60, minWidth: 40),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        isRTL ? 0 : 42, 0, isRTL ? 56 : 0, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    width: isRTL ? 250 : 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            modle.isAuthintecated
                                ? modle.username
                                : trans(context, "login_or_sign_up") ??
                                    config.username,
                            style: styles.underHead)
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                )),
            Align(
                alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                child: CircleAvatar(
                  maxRadius: 40,
                  minRadius: 30,
                  child: CachedNetworkImage(
                    placeholderFadeInDuration:
                        const Duration(milliseconds: 300),
                    imageUrl:
                        modle.userPicture ?? config.profileUrl.trim() ?? "",
                    imageBuilder:
                        (BuildContext context, ImageProvider imageProvider) =>
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
                    errorWidget:
                        (BuildContext context, String url, dynamic error) =>
                            const Icon(Icons.error),
                  ),
                )),
          ],
        ),
        // Align(
        //   alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
        //   child: InkWell(
        //     onTap: () {
        //       // Navigator.pop(context);
        //       goToMap(context);
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(8),
        //       child: Wrap(
        //         children: <Widget>[
        //           Text(trans(context, 'back_to_map')),
        //           const SizedBox(width: 16),
        //           Icon(Icons.keyboard_return, color: colors.orange)
        //         ],
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
