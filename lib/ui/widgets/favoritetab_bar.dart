import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:provider/provider.dart';

class FavoritBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Color getColor(Set<MaterialState> states) {
    //   const Set<MaterialState> interactiveStates = <MaterialState>{
    //     MaterialState.pressed,
    //     MaterialState.hovered,
    //     MaterialState.focused,
    //   };
    //   if (states.any(interactiveStates.contains)) {
    //     return Colors.blue;
    //   }
    //   return Colors.red;
    // }

    final MainProvider bolc = Provider.of<MainProvider>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colors.white,
          border: Border.all(color: colors.orange, width: 1)),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      // color: Colors.grey[100],
      child: Row(
        children: <Widget>[
          Expanded(
              // child: Visibility(
              child: TextButton(
            onPressed: () {
              if (bolc.favocurrentIndex == 1) {
                bolc.changeTabBarIndex(0);
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) => colors.orange),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                    (Set<MaterialState> states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: colors.orange))),
                textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                    (Set<MaterialState> states) =>
                        TextStyle(color: colors.white))),
            // style: ElevatedButton.styleFrom(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            //     shadowColor: colors.ggrey),
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
                    opacity: bolc.visible1 ? 1.0 : 0.0,
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
          )

              // visible: bolc.visible1,
              // replacement: FlatButton(
              //     padding: EdgeInsets.zero,
              //     textColor: colors.black,
              //     disabledColor: colors.grey,
              //     splashColor: colors.trans,
              //     highlightColor: colors.trans,
              //     onPressed: () {
              //       if (bolc.favocurrentIndex == 1) {
              //         bolc.changeTabBarIndex(0);
              //       }
              //     },
              //     child: Stack(
              //       children: <Widget>[
              //         AnimatedOpacity(
              //             opacity: bolc.visible2 ? 1.0 : 0.0,
              //             duration: const Duration(milliseconds: 700),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                       const BorderRadius.all(Radius.circular(12)),
              //                   color: colors.trans),
              //               alignment: Alignment.center,
              //               height: 50,
              //               width: MediaQuery.of(context).size.width * .5,
              //               child: Text(trans(context, 'stores'),
              //                   style: styles.underHeadorange),
              //             ))
              //       ],
              //     )),
              //)
              ),
          Expanded(
            //  child: Visibility(
            child: TextButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    // textColor: colors.black,
                    // disabledColor: colors.grey,
                    // splashColor: colors.trans,
                    // highlightColor: colors.trans,
                    textStyle: TextStyle(color: colors.black)),
                onPressed: () {
                  if (bolc.favocurrentIndex == 0) {
                    bolc.changeTabBarIndex(1);
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
                        opacity: bolc.visible2 ? 1.0 : 0.0,
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
            // visible: bolc.visible2,
            // replacement: FlatButton(
            //     padding: EdgeInsets.zero,
            //     textColor: colors.black,
            //     disabledColor: colors.grey,
            //     splashColor: colors.trans,
            //     highlightColor: colors.trans,
            //     onPressed: () {
            //       if (bolc.favocurrentIndex == 0) {
            //         bolc.changeTabBarIndex(1);
            //       }
            //     },
            //     child: Stack(
            //       children: <Widget>[
            //         AnimatedOpacity(
            //             opacity: bolc.visible1 ? 1.0 : 0.0,
            //             duration: const Duration(milliseconds: 800),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                   borderRadius: const BorderRadius.all(
            //                       Radius.circular(12)),
            //                   color: colors.white),
            //               alignment: Alignment.center,
            //               height: 50,
            //               width: MediaQuery.of(context).size.width * .5,
            //               child: Text(trans(context, 'discounts'),
            //                   style: styles.underHeadorange),
            //             ))
            //       ],
            //     ))),
          )
        ],
      ),
    );
  }
}
