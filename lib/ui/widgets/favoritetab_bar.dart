import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/ui/view_models/favorite_modle.dart';

class FavoritBar extends StatelessWidget {
  const FavoritBar({Key key, this.favoritModle}) : super(key: key);
  final FavoriteModle favoritModle;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colors.white,
          border: Border.all(color: colors.orange, width: 1)),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextButton(
            onPressed: () {
              if (favoritModle.favocurrentIndex == 1) {
                favoritModle.changeTabBarIndex(0);
              }
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                    (Set<MaterialState> stets) => EdgeInsets.zero),
                textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                    (Set<MaterialState> states) =>
                        TextStyle(color: colors.white))),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: colors.white),
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width * .5,
                  child: Text(trans(context, 'stores'),
                      style: styles.underHeadorange),
                ),
                AnimatedOpacity(
                    opacity: favoritModle.visible1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 700),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: colors.orange),
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(trans(context, 'stores'),
                          style: styles.underHeadwhite2),
                    ))
              ],
            ),
          )),
          Expanded(
            child: TextButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                            (Set<MaterialState> stets) => EdgeInsets.zero),
                    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                        (Set<MaterialState> states) =>
                            TextStyle(color: colors.white))),
                onPressed: () {
                  if (favoritModle.favocurrentIndex == 0) {
                    favoritModle.changeTabBarIndex(1);
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: colors.white),
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(trans(context, 'discounts'),
                          style: styles.underHeadorange),
                    ),
                    AnimatedOpacity(
                        opacity: favoritModle.visible2 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: colors.orange),
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text(trans(context, 'discounts'),
                              style: styles.underHeadwhite2),
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
