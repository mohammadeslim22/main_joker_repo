import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:provider/provider.dart';

class BottomContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);

    return Container(
      color: Colors.black,
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            color: colors.trans,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  height: 2,
                ),
                Container(
                  color: colors.trans,
                  child: SvgPicture.asset(
                    'assets/images/sales.svg',
                    color: bolc.bottomNavIndex == 0
                        ? colors.red
                        : colors.red.withOpacity(0.6),
                    height: bolc.bottomNavIndex == 1 ? 20 : 25,
                    width: bolc.bottomNavIndex == 1 ? 25 : 35,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${trans(context, 'sales')}',
                  style: styles.mylight,
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 2,
                  width: MediaQuery.of(context).size.width * .4,
                  color:
                      bolc.bottomNavIndex == 0 ? Colors.orange : colors.trans,
                )
              ],
            ),
            onPressed: () {
              if (bolc.bottomNavIndex == 0) {
              } else {
                bolc.changebottomNavIndex(0);
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: VerticalDivider(
              color: Colors.orange,
              width: 1,
            ),
          ),
          RaisedButton(
            color: colors.trans,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Container(
                  color: colors.trans,
                  child: SvgPicture.asset(
                    'assets/images/merchants.svg',
                    color: bolc.bottomNavIndex == 1
                        ? colors.red
                        : colors.red.withOpacity(0.6),
                    height: bolc.bottomNavIndex == 0 ? 20 : 25,
                    width: bolc.bottomNavIndex == 0 ? 25 : 35,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${trans(context, 'merchants')}',
                  style: styles.mylight,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 2,
                  width: MediaQuery.of(context).size.width * .4,
                  color:
                      bolc.bottomNavIndex == 1 ? Colors.orange : colors.trans,
                )
              ],
            ),
            onPressed: () {
              if (bolc.bottomNavIndex == 1) {
              } else {
                bolc.changebottomNavIndex(1);
              }
            },
          ),
        ],
      ),
    );
  }
}
