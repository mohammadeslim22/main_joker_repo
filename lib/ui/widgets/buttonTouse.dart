import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';

class ButtonToUse extends StatelessWidget {
  const ButtonToUse(this.buttonstring, {this.fontWait, this.fontColors, this.onPressed, this.width});
  final String buttonstring;
  final FontWeight fontWait;
  final Color fontColors;
  final Function onPressed;
  final double width;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.padded,
        highlightElevation: 0,
        color: colors.trans,
        elevation: 0,
        child: Container(
          width: width,
          alignment: Alignment.center,
          child: Text(
            buttonstring,
            style: TextStyle(
              color: fontColors,
              fontSize: 15,
              fontWeight: fontWait,
            ),
          ),
        ),
        onPressed: () => onPressed());
  }
}
