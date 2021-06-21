import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/base_widget.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/language.dart';
import 'package:joker/ui/view_models/settings_modle.dart';
import 'package:joker/util/service_locator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'widgets/setting_bottombar.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/constants/config.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  MySettingState createState() => MySettingState();
}

class MySettingState extends State<SettingsScreen> {
  bool doOnce = true;
  int sountState = 0;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(trans(context, "settings"), style: styles.mystyle)),
      body: BaseWidget<SettingsModle>(
          onModelReady: (SettingsModle modle) async {
            modle.getSettingsReady();
          },
          model: getIt<SettingsModle>(),
          builder: (BuildContext context, SettingsModle modle, Widget child) =>
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SvgPicture.asset('assets/images/settingsvg.svg',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .35),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(trans(context, "notification_sound"),
                            style: styles.mystyle),
                        Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ToggleButtons(
                            color: Colors.grey,
                            fillColor: Colors.orange[100],
                            selectedColor: colors.orange,
                            children: const <Widget>[
                              Icon(Icons.notifications_active),
                              Icon(Icons.notifications_paused),
                            ],
                            onPressed: (int index) async {
                              modle.changenotificationSit(index);
                              dio.post<dynamic>("settings",
                                  data: <String, dynamic>{
                                    'notify_sound': index == 0 ? "on" : "off"
                                  });

                              if (index == 0) {
                                await data.setData("notification_sound", "on");
                                OneSignal.shared.setInFocusDisplayType(
                                    OSNotificationDisplayType.notification);
                              } else {
                                await data.setData("notification_sound", "off");
                                OneSignal.shared.setInFocusDisplayType(
                                    OSNotificationDisplayType.none);
                              }
                            },
                            isSelected: modle.notificationSit,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(trans(context, "recieving_offers_notifies"),
                            style: styles.mystyle),
                        Switch(
                          activeColor: colors.orange,
                          onChanged: (bool value) {
                            modle.toggleNotificationSound(value);
                          },
                          value: modle.notificationSound,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: colors.white,
                    child: Row(
                      children: <Widget>[
                        Text(trans(context, "language"), style: styles.mystyle),
                        Flexible(
                            child: Container(child: languagBar(context, modle)))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: getIt<Auth>().isAuthintecated,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/ChangePassword");
                            },
                            child: Text(trans(context, "change_password"),
                                style: TextStyle(color: colors.black)))),
                  )
                ],
              )),
      bottomNavigationBar: Visibility(
          visible: getIt<Auth>().isAuthintecated, child: SettingBottom()),
    );
  }
}

Widget fontBarChoice(BuildContext context, String choice, int index, bool list,
    String category, Function func, SettingsModle modle) {
  return Flexible(
      fit: FlexFit.tight,
      child: TextButton(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: colors.black),
            onSurface: Colors.grey,
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () async {
            print("choice $choice");
            if (choice == "arabic") {
              await data.setData("ilang", "ar");
              print("await data.getData('lang') ${await data.getData("ilang")}");
            } else if (choice == 'english') {
              await data.setData("ilang", "en");
            } else {
              await data.setData("ilang", "tr");
            }

            modle.changelanguageindex(index);
            func();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                trans(context, choice),
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.black),
              ),
              const SizedBox(height: 3),
              AnimatedOpacity(
                  opacity: list ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        color: colors.orange),
                    alignment: Alignment.bottomCenter,
                    height: 3,
                    width: MediaQuery.of(context).size.width * .15,
                  ))
            ],
          )));
}

Widget languagBar(BuildContext context, SettingsModle modle) {
  final Language lang = Provider.of<Language>(context);
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        fontBarChoice(
            context, "arabic", 0, modle.language.indexOf(true) == 0, "language",
            () {
          lang.setLanguage(const Locale('ar'));
          config.userLnag = const Locale('ar');
        }, modle),
        verticalDiv(),
        fontBarChoice(context, "english", 1, modle.language.indexOf(true) == 1,
            "language", () {
          lang.setLanguage(const Locale('en'));
          config.userLnag = const Locale('en');
        }, modle),
        verticalDiv(),
        fontBarChoice(context, "turkish", 2, modle.language.indexOf(true) == 2,
            "language", () {
          lang.setLanguage(const Locale('tr'));
          config.userLnag = const Locale('tr');
        }, modle),
      ],
    ),
  );
}

Widget verticalDiv() {
  return Container(
      child: const VerticalDivider(color: Colors.grey, thickness: 1),
      height: 18);
}
