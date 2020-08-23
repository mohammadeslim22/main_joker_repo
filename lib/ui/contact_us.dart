import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:joker/ui/widgets/countryCodePicker.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    Widget simpleForm(int minLines, int maxLines, String text,
        {Widget sufixIcon, Widget suffix}) {
      return TextFormField(
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.white,
            hintText: text,
            hintStyle: TextStyle(
              color: colors.ggrey,
              fontSize: 15,
            ),
            suffixIcon: sufixIcon,
            suffix: suffix,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: colors.ggrey,
            )),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title:  Text(trans(context,'contact_us'),style: styles.appBars),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(trans(context, 'hello'), style: styles.mystyle2),
                  const SizedBox(height: 10),
                  Text(trans(context, 'happy_to_recieve_message'))
                ],
              ),
              Flexible(
                child: SvgPicture.asset("assets/images/contact_us.svg"),
              )
            ],
          ),
          const SizedBox(height: 36),
          simpleForm(1, 3, "Name"),
          const SizedBox(height: 16),
          simpleForm(1, 3, "Emai"),
          const SizedBox(height: 16),
          simpleForm(
            1,
            3,
            "Mobile Number",
            sufixIcon:CountryPickerCode(onCountryChange:_onCountryChange,isRTL:isRTL),
            //  CountryCodePicker(
            //   onChanged: _onCountryChange,
            //   initialSelection: 'SA',
            //   favorite: const <String>['+966', 'SA'],
            //   showFlagDialog: true,
            //   showFlag: false,
            //   showCountryOnly: false,
            //   showOnlyCountryWhenClosed: false,
            //   alignLeft: false,
            //   padding: isRTL == true
            //       ? const EdgeInsets.fromLTRB(0, 0, 32, 0)
            //       : const EdgeInsets.fromLTRB(32, 0, 0, 0),
            // ),
          ),
          const SizedBox(height: 12),
          simpleForm(1, 3, "Address"),
          const SizedBox(height: 12),
          simpleForm(3, 5, "Message"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: colors.jokerBlue)),
                onPressed: () async {},
                color: colors.blue,
                textColor: colors.white,
                child: Text(trans(context, 'send'))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              techSupport("للتواصل المباشر", "+9956878529"),
              techSupport("البريد الإلكتروني", "+joker@gmail.com")
            ],
          ),
          const SizedBox(height: 12)
        ],
      ),
    );
  }

  Widget techSupport(String one, String two) {
    return Column(
      children: <Widget>[
        Text(one, style: styles.mysmalllight),
        const SizedBox(height: 5),
        Text(two, style: styles.mysmall),
      ],
    );
  }

  void _onCountryChange(CountryCode value) {}
}
