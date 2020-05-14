import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';


class SettingBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(trans(context, "user_account")),
          RaisedButton(
            splashColor: Colors.transparent,
            highlightElevation: 0,
            highlightColor: Colors.transparent,
            elevation: 0,
            color: colors.trans,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 Image.asset(
                  "assets/images/delete.png",
                  height: 20,
                  width: 20,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  trans(context, "cancel_account"),
                  style: styles.redstyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
