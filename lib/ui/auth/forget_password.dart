import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/text_form_input.dart';
import 'package:provider/provider.dart';
import 'package:joker/ui/widgets/country_code_picker.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _MyForgetPassState createState() => _MyForgetPassState();
}

class _MyForgetPassState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  String gotCode;
  bool _isButtonEnabled = true;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title:  Text(trans(context, "are_you_sure")),
            content:  Text(trans(context, "do_u_want_to_exit")),
            actionsOverflowButtonSpacing: 50,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(trans(context, "cancel")),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child:  Text(trans(context, "yes")),
              ),
            ],
          ),
        )) ??
        false;
  }

  bool codeArrived = false;
  String mainButtonkey = "send_code";
  final TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentText = "0000";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(trans(context, 'reset_password'),
                          style: styles.mystyle2),
                      const SizedBox(height: 10),
                      Text(trans(context, 'enter_mobile_no'),
                          style: styles.mystyle),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: TextFormInput(
                            text: trans(context, 'mobile_number'),
                            cController: mobileController,
                            prefixIcon: Icons.settings_phone,
                            kt: TextInputType.phone,
                            obscureText: false,
                            readOnly: false,
                            onTab: () {},
                            suffixicon: CountryPickerCode(
                                context: context, isRTL: isRTL),
                            onFieldSubmitted: () {},
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "mobile_number is needed";
                              }
                              if (value.length < 6) {
                                return "mobile_number must be more than 3 letters";
                              }
                              return getIt<Auth>()
                                  .forgetPassValidationMap['phone'];
                            }),
                      ),
                      const SizedBox(height: 36),
                      if (codeArrived)
                        Text(trans(context, "enter_code_u_just_recieved"),
                            style: styles.mystyle)
                      else
                        Container(),
                      SafeArea(
                        child: Container(
                          width: 190,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          decoration: BoxDecoration(
                            color: colors.white,
                            border: Border.all(color: colors.ggrey, width: 1),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 160,
                                child: PinCodeTextField(
                                  length: 4,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  keyboardType: TextInputType.phone,
                                  onCompleted: (String v) async {
                                    getIt<Auth>().verifyCode(
                                        mobileController.text, v, context);
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      currentText = value;
                                    });
                                  },
                                  appContext: context,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: colors.orange)),
                                onPrimary: colors.orange,
                                textStyle: TextStyle(color: colors.white)),
                            onPressed: () async {
                              if (_isButtonEnabled) {
                                if (_formKey.currentState.validate()) {
                                  if (codeArrived) {
                                  } else {
                                    bolc.togelfForgetPass(true);
                                    setState(() {
                                      _isButtonEnabled = false;
                                    });

                                    await getIt<Auth>()
                                        .resendCode(
                                            mobileController.text.toString())
                                        .then((bool value) {
                                      if (value) {
                                        setState(() {
                                          codeArrived = true;
                                          mainButtonkey =
                                              trans(context, 'submet');
                                        });
                                      }
                                      getIt<Auth>()
                                          .forgetPassValidationMap
                                          .updateAll(
                                              (String key, String value) {
                                        return null;
                                      });
                                    });
                                  }

                                  bolc.togelfForgetPass(false);
                                }
                              }
                            },
                            child: bolc.returnchildForgetPass(
                                trans(context, mainButtonkey))),
                      ),
                      const SizedBox(height: 36),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: colors.black)),
                          onPrimary: colors.white,
                          textStyle: TextStyle(color: colors.blue),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 28),
                        ),
                        onPressed: () {},
                        child: Text(
                          trans(context, 'resend_code'),
                          style: styles.resend,
                        ),
                      ),
                    ],
                  ),
                ]),
          )),
    );
  }
}
