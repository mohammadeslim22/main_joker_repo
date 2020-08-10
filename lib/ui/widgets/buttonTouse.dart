import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';

class ButtonToUse extends StatelessWidget {
  const ButtonToUse(this.buttonstring, {this.fw, this.fc, this.onPressed, this.width});
  final String buttonstring;
  final FontWeight fw;
  final Color fc;
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
              color: fc,
              fontSize: 15,
              fontWeight: fw,
            ),
          ),
        ),
        onPressed: () => onPressed());
  }
}
