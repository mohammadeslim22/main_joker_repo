import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/providers/language.dart';
import 'package:provider/provider.dart';
import 'widgets/setting_bottombar.dart';

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

class MySettingState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  String dropdownValue = 'كتم';
  @override
  Widget build(BuildContext context) {
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
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Text(
                    trans(context, "font"),
                    style: styles.mystyle,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(child: fontBar(context)),
                  )
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  trans(context, "notification_sound"),
                  style: styles.mystyle,
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black),
                  items: <String>['كتم', 'صوت']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                  onChanged: switchChanged,
                  value: true,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Text(
                  trans(context, "language"),
                  style: styles.mystyle,
                ),
                Flexible(child: Container(child: languagBar(context)))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
              child: FlatButton(
                  onPressed: () {},
                  child: Text(trans(context, "change_password"))))
        ],
      ),
      bottomNavigationBar: SettingBottom(),
    );
  }

  void switchChanged(bool value) {}
}

Widget fontBarChoice(BuildContext context, String choice, int index,
    List<bool> list, String category, Function func) {
  final MyCounter bolc = Provider.of<MyCounter>(context);
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
              const SizedBox(
                height: 3,
              ),
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

Widget fontBar(BuildContext context) {
  final MyCounter bolc = Provider.of<MyCounter>(context);

  return Container(
    child: Row(
      children: <Widget>[
        fontBarChoice(context, "large", 0, bolc.fontlist, "font", () {}),
        verticalDiv(),
        fontBarChoice(context, "meduim", 1, bolc.fontlist, "font", () {}),
        verticalDiv(),
        fontBarChoice(context, "small", 2, bolc.fontlist, "font", () {}),
      ],
    ),
  );
}

Widget languagBar(BuildContext context) {
  final MyCounter bolc = Provider.of<MyCounter>(context);
  final Language lang = Provider.of<Language>(context);
  print("${lang.currentLanguage}");
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        fontBarChoice(context, "arabic", 0, bolc.language, "language", () {
          lang.setLanguage(const Locale('ar'));
        }),
        verticalDiv(),
        fontBarChoice(context, "english", 1, bolc.language, "language", () {
          lang.setLanguage(const Locale('en'));
        }),
        verticalDiv(),
        fontBarChoice(context, "turkish", 2, bolc.language, "language", () {}),
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
    height: 18,
  );
}
