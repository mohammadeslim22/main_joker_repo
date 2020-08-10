import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/providers/language.dart';
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

  Future<void> setStartingLang(MainProvider bolc, Language lang) async {
    await data.getData("lang").then<dynamic>((String value) async {
      if (value.isEmpty) {
        print("here in settings and this is lang empty");

        await data.getData("initlang").then<dynamic>((String local) {
          print("here in settings and this is lang $local");

          if (local == 'en') {
            bolc.changelanguageindex(1);
          } else if (local == 'ar') {
            bolc.changelanguageindex(0);
          } else {
            bolc.changelanguageindex(2);
          }
        });
      } else {
        print("here in settings and this is lang $value");
        if (value == 'en') {
          bolc.changelanguageindex(1);
        } else if (value == 'ar') {
          bolc.changelanguageindex(0);
        } else {
          bolc.changelanguageindex(2);
        }
      }
    });
  }

  Future<void> setNotifcationSound(MainProvider bolc) async {
    data.getData("notification_sound").then<dynamic>((String value) {
      if (value == "true") {
        bolc.changenotificationSit(0);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);
    final Language lang = Provider.of<Language>(context);

    if (doOnce) {
      setStartingLang(bolc, lang);
      setNotifcationSound(bolc);
      setState(() {
        doOnce = false;
      });
    }
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans(context, "settings"),
            style: styles.mystyle,
          )),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/settingsvg.svg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .35,
          ),
          // Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     color: Colors.white,
          //     child: Row(
          //       children: <Widget>[
          //         Text(trans(context, "font"), style: styles.mystyle),
          //         const SizedBox(width: 3),
          //         Flexible(
          //           fit: FlexFit.tight,
          //           child: Container(child: fontBar(context)),
          //         )
          //       ],
          //     )),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
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
                    selectedColor: Colors.orange,
                    children: <Widget>[
                      Icon(Icons.notifications_active),
                      Icon(Icons.notifications_paused),
                    ],
                    onPressed: (int index) async {
                      dio.post<dynamic>("settings", data: <String, dynamic>{
                        'notify_sound': index == 0 ? "on" : "off"
                      });
                      if (index == 0) {
                        bolc.changenotificationSit(0);
                        await data.setData("notification_sound", "true");
                      } else {
                        bolc.changenotificationSit(1);
                        await data.setData("notification_sound", "false");
                      }
                    },
                    isSelected: bolc.notificationSit,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  trans(context, "recieving_offers_notifies"),
                  style: styles.mystyle,
                ),
                Switch(
                  activeColor: Colors.orange,
                  onChanged: (bool value) {
                    dio.post<dynamic>("settings", data: <String, dynamic>{
                      'recieve_notify': value ? "on" : "off"
                    });
                  },
                  value: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Text(trans(context, "language"), style: styles.mystyle),
                Flexible(child: Container(child: languagBar(context)))
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/ChangePassword");
                  },
                  child: Text(trans(context, "change_password"))))
        ],
      ),
      bottomNavigationBar: SettingBottom(),
    );
  }
}

Widget fontBarChoice(BuildContext context, String choice, int index,
    List<bool> list, String category, Function func) {
  final MainProvider bolc = Provider.of<MainProvider>(context);
  return Flexible(
      fit: FlexFit.tight,
      child: FlatButton(
          textColor: Colors.black,
          disabledColor: Colors.grey,
          padding: const EdgeInsets.all(0),
          splashColor: colors.trans,
          highlightColor: colors.trans,
          onPressed: () {
            if (category == "font")
              bolc.changefontindex(index);
            else {
              if (choice == "arabic") {
                data.setData("lang", "ar");
              } else if (choice == 'english') {
                data.setData("lang", "en");
              } else {
                data.setData("lang", "tr");
              }

              bolc.changelanguageindex(index);
              func();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                trans(context, choice),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              AnimatedOpacity(
                  opacity: list[index] ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        color: Colors.orange),
                    alignment: Alignment.bottomCenter,
                    height: 3,
                    width: MediaQuery.of(context).size.width * .15,
                  ))
            ],
          )));
}

// Widget fontBar(BuildContext context) {
//   final MyCounter bolc = Provider.of<MyCounter>(context);

//   return Container(
//     child: Row(
//       children: <Widget>[
//         fontBarChoice(context, "large", 0, bolc.fontlist, "font", () {}),
//         verticalDiv(),
//         fontBarChoice(context, "meduim", 1, bolc.fontlist, "font", () {}),
//         verticalDiv(),
//         fontBarChoice(context, "small", 2, bolc.fontlist, "font", () {}),
//       ],
//     ),
//   );
// }

Widget languagBar(BuildContext context) {
  final MainProvider bolc = Provider.of<MainProvider>(context);
  final Language lang = Provider.of<Language>(context);
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        fontBarChoice(context, "arabic", 0, bolc.language, "language", () {
          lang.setLanguage(const Locale('ar'));
          config.userLnag = const Locale('ar');
        }),
        verticalDiv(),
        fontBarChoice(context, "english", 1, bolc.language, "language", () {
          lang.setLanguage(const Locale('en'));
          // setState(() {});
          config.userLnag = const Locale('en');
        }),
        verticalDiv(),
        fontBarChoice(context, "turkish", 2, bolc.language, "language", () {
          lang.setLanguage(const Locale('tr'));
          config.userLnag = const Locale('tr');
        }),
      ],
    ),
  );
}

Widget verticalDiv() {
  return Container(
      child: const VerticalDivider(
        color: Colors.grey,
        thickness: 1,
      ),
      height: 18);
}
