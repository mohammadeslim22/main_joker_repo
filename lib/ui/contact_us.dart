import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/ui/widgets/countryCodePicker.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/functions.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final TextEditingController name = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController mobile = TextEditingController();
    final TextEditingController address = TextEditingController();
    final TextEditingController message = TextEditingController();
    Widget simpleForm(int minLines, int maxLines, String text,
        TextEditingController controller,
        {Widget sufixIcon, Widget suffix, TextInputType tit}) {
      return TextFormField(
          minLines: minLines,
          maxLines: maxLines,
          controller: controller,
          keyboardType: tit,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.white,
            hintText: trans(context, text),
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
        title: Text(trans(context, 'contact_us'), style: styles.appBars),
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
          const SizedBox(height: 2),
          simpleForm(1, 3, "name", name),
          // const SizedBox(height: 16),
          // simpleForm(1, 3, "email", email),
          // const SizedBox(height: 16),
          // simpleForm(1, 3, "mobile_number", mobile,
          //     sufixIcon: CountryPickerCode(context: context, isRTL: isRTL),
          //     tit: TextInputType.number),
          const SizedBox(height: 8),
          simpleForm(1, 3, "address", address),
          const SizedBox(height: 8),
          simpleForm(3, 5, "message", message),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: colors.orange)),
                    onPrimary: colors.orange,
                    textStyle: TextStyle(color: colors.white)),
                onPressed: () async {
                  final Response<dynamic> response = await dio
                      .post<dynamic>("contact", data: <String, dynamic>{
                    "email": email.text,
                    "phone": mobile.text ?? await data.getData("phone"),
                    "address": address.text ?? await data.getData("address"),
                    "body": message.text ?? ""
                  });
                  if (response.statusCode == 200) {
                    ifUpdateTur(context, "message_sent_successfully");
                  } else {
                    showToastWidget(
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/images/ic_fail.png",
                                  height: 60, width: 60, color: colors.ggrey),
                              const SizedBox(width: 12),
                              Text(trans(context, 'message_sending_failed')),
                            ],
                          ),
                        ),
                        context: context,
                        position: StyledToastPosition.center,
                        animation: StyledToastAnimation.scale,
                        reverseAnimation: StyledToastAnimation.fade,
                        duration: const Duration(seconds: 4),
                        animDuration: const Duration(seconds: 1),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.linear);
                  }
                },
                child: Text(trans(context, 'send'))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              techSupport(trans(context, "direct_contact"), "+9956878529"),
              techSupport(trans(context, "email"), "joker@gmail.com")
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
}
