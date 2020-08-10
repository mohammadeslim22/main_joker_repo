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
    final MainProvider bolc = Provider.of<MainProvider>(context);
    return Container(
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
              child: FlatButton(
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  padding: const EdgeInsets.all(18.0),
                  splashColor: colors.trans,
                  highlightColor: colors.trans,
                  onPressed: () {
                    if(bolc.favocurrentIndex==1){
                      bolc.changeTabBarIndex(0);
                    }
                    
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        trans(context, 'stores'),
                        style: styles.underHeadblack,
                      ),
                      AnimatedOpacity(
                          opacity: bolc.visible1 ? 1.0 :0.0,
                          duration:const Duration(milliseconds: 700),
                          child: Container(
                            decoration:const BoxDecoration(
                              borderRadius:  BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                                   color:Colors.orange
                            ),
                            alignment: Alignment.bottomCenter,
                            height: 5,
                            width: MediaQuery.of(context).size.width * .4,
                          ))
                    ],
                  ))),
          Container(
            child: const VerticalDivider(
              color: Colors.grey,
              thickness: 1,
            ),
            height: 28,
          ),
          Flexible(
              child: FlatButton(
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  padding:const EdgeInsets.all(18.0),
                  splashColor: colors.trans,
                  highlightColor: colors.trans,
                  onPressed: () {
                        if(bolc.favocurrentIndex==0){
                      bolc.changeTabBarIndex(1);
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        trans(context, 'discounts'),
                        style: styles.underHeadblack,
                      ),
                      AnimatedOpacity(
                          opacity: bolc.visible2 ? 1.0 : 0.0,
                          duration:const Duration(milliseconds: 800),
                          child: Container(
                            decoration:const BoxDecoration(
                              borderRadius:  BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                                  color:Colors.orange
                            ),
                            alignment: Alignment.bottomCenter,
                            height: 5,
                            width: MediaQuery.of(context).size.width * .4,
                          ))
                    ],
                  ))),
        ],
      ),
    );
  }
}
