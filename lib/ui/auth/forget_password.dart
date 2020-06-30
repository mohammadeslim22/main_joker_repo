import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/text_form_input.dart';
import 'package:provider/provider.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/data.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _MyForgetPassState createState() => _MyForgetPassState();
}

class _MyForgetPassState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  String gotCode;

  bool _isButtonEnabled = true;
  static List<String> validators = <String>[null];
  static List<String> keys = <String>[
    'phone',
  ];
  Map<String, String> validationMap =
      Map<String, String>.fromIterables(keys, validators);
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App'),
            actionsOverflowButtonSpacing: 50,
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
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
  Widget build(BuildContext context) {
    final MyCounter bolc = Provider.of<MyCounter>(context);
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
                            onFieldSubmitted: () {},
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "mobile_number is needed";
                              }
                              if (value.length < 6) {
                                return "mobile_number must be more than 3 letters";
                              }
                              return validationMap['phone'];
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
                          width: 160,
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
                                width: 140,
                                child: PinCodeTextField(
                                  length: 4,
                                  obsecureText: false,
                                  animationType: AnimationType.fade,
                                  shape: PinCodeFieldShape.box,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  borderRadius: BorderRadius.circular(5),
                                  inactiveColor: Colors.grey,
                                  textInputType: TextInputType.phone,
                                  fieldHeight: 40,
                                  fieldWidth: 30,
                                  onCompleted: (String v) async {
                                    final Response<dynamic> correct = await dio
                                        .post<dynamic>("verfiy",
                                            data: <String, dynamic>{
                                          "phone":
                                              mobileController.text.toString(),
                                          "verfiy_code": v
                                        });
                                    print(correct.data);
                                    if (correct.data == "false") {
                                      showToast(
                                          'The Code You Enterd Was Not Correct',
                                          context: context,
                                          textStyle: styles.underHeadblack,
                                          animation: StyledToastAnimation.scale,
                                          reverseAnimation:
                                              StyledToastAnimation.fade,
                                          position: StyledToastPosition.center,
                                          animDuration:
                                              const Duration(seconds: 1),
                                          duration: const Duration(seconds: 4),
                                          curve: Curves.elasticOut,
                                          backgroundColor: colors.white,
                                          reverseCurve: Curves.decelerate);
                                    } else {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/Reset_pass', (_) => false);
                                    }
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      currentText = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: colors.orange)),
                            onPressed: () async {
                              if (_isButtonEnabled) {
                                if (_formKey.currentState.validate()) {
                                  if (codeArrived) {
                                  } else {
                                    bolc.togelf(true);
                                    setState(() {
                                      _isButtonEnabled = false;
                                    });
                                    dio.post<dynamic>("resend",
                                        data: <String, dynamic>{
                                          "phone":
                                              mobileController.text.toString()
                                        }).then(
                                        (Response<dynamic> value) async {
                                      setState(() {
                                        _isButtonEnabled = true;
                                      });
                                      if (value.statusCode == 422) {
                                        value.data['errors']
                                            .forEach((String k, dynamic vv) {
                                          setState(() {
                                            validationMap[k] = vv[0].toString();
                                          });
                                        });
                                        _formKey.currentState.validate();
                                        validationMap.updateAll(
                                            (String key, String value) {
                                          return null;
                                        });
                                      } else if (value.statusCode == 200) {
                                        await data.setData("phone",
                                            mobileController.text.toString());
                                        print(value.data);
                                        setState(() {
                                          codeArrived = true;
                                          mainButtonkey = "submet";
                                        });
                                      }
                                    });
                                  }

                                  bolc.togelf(false);
                                }
                              }
                            },
                            color: Colors.deepOrangeAccent,
                            textColor: Colors.white,
                            child: bolc
                                .returnchild(trans(context, mainButtonkey))),
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: Colors.black)),
                        color: Colors.white,
                        textColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 28),
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
