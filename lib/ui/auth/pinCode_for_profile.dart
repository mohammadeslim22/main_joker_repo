import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/ui/widgets/text_form_input.dart';
import 'package:joker/util/data.dart';
import '../widgets/buttonTouse.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:joker/constants/colors.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/dio.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PinCodeForProfile extends StatefulWidget {
  const PinCodeForProfile({Key key, this.mobileNo}) : super(key: key);
  final String mobileNo;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PinCodeForProfile>
    with TickerProviderStateMixin {
  AnimationController controller;
  String currentText = "0000";
  bool showTimer = true;
  String countryCodeTemp = "+90";

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    setState(() {
      config.prifleNoVerfiyVisit = true;
    });
        data.getData("countryDialCodeTemp").then((String value) {
      setState(() {
        countryCodeTemp = value;
      });
    });
  }

  Future<bool> getPinCode(String code) async {
    final Response<dynamic> correct = await dio.put<dynamic>("save_phone",
        data: <String, dynamic>{
          "new_phone": countryCodeTemp + mobileNoController.text,
          "verfiy_code": code
        });
    print(correct.data);
    if (correct.data == "false") {
      print(correct.data);
      return false;
    } else {
      print(correct.data);
      return true;
    }
  }

  bool enabeld = false;
  Widget pinCode(MainProvider bolc) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        decoration: BoxDecoration(
          color: colors.white,
          border: Border.all(
            color: colors.ggrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 140,
              child: PinCodeTextField(
                enabled: enabeld,
                length: 4,
                obsecureText: false,
                animationType: AnimationType.fade,
                shape: PinCodeFieldShape.box,
                animationDuration: const Duration(milliseconds: 300),
                borderRadius: BorderRadius.circular(5),
                inactiveColor: Colors.grey,
                textInputType: TextInputType.phone,
                fieldHeight: 40,
                fieldWidth: 30,
                onCompleted: (String v) async {
                  bolc.togelf(true);
                  if (await getPinCode(v.trim())) {
                    setState(() {
                      config.prifleNoVerfiyDone = true;
                    });
                    Navigator.pushNamed(context, '/Profile');
                  }
                  bolc.togelf(false);
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
    );
  }

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController mobileNoController = TextEditingController();
  bool _obscureText = false;
  final FocusNode focus = FocusNode();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static List<String> validators = <String>[null, null];
  static List<String> keys = <String>[
    'phone',
    'password',
  ];
  Map<String, String> validationMap =
      Map<String, String>.fromIterables(keys, validators);

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final MainProvider bolc = Provider.of<MainProvider>(context);
    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(children: <Widget>[
              const SizedBox(height: 20),
              Text(trans(context, 'pin_code'),
                  textAlign: TextAlign.center, style: styles.mystyle2),
              const SizedBox(height: 15),
              Text(trans(context, 'pin_has_been_sent'),
                  textAlign: TextAlign.center, style: styles.underHead),
              const SizedBox(height: 15),
              Text("${widget.mobileNo}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 18,
                  )),
              Text(trans(context, 'enter_your_pass_s_u_can_change_phone'),
                  textAlign: TextAlign.center, style: styles.underHead),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormInput(
                        text: trans(context, 'password'),
                        cController: passwordController,
                        prefixIcon: Icons.lock_outline,
                        kt: TextInputType.visiblePassword,
                        readOnly: false,
                        onTab: () {},
                        suffixicon: IconButton(
                          icon: Icon(
                            (_obscureText == false)
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        obscureText: _obscureText,
                        focusNode: focus,
                        onFieldSubmitted: () async {
                          focus2.requestFocus();
                        },
                        validator: (String value) {
                          if (passwordController.text.length < 6) {
                            return "password must be more than 6 letters";
                          }
                          return validationMap['password'];
                        }),
                  ],
                ),
              ),
              TextFormInput(
                text: trans(context, 'new_mobile_no'),
                cController: mobileNoController,
                prefixIcon: Icons.phone,
                kt: TextInputType.phone,
                obscureText: false,
                readOnly: false,
                // onTab: () {},
                suffixicon: CountryCodePicker(
                  onChanged: _onCountryChange,
                  initialSelection:bolc.countryCode,
                  favorite: const <String>['+972', 'IS'],
                  showFlagDialog: true,
                  showFlag: false,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: isRTL == true
                      ? const EdgeInsets.fromLTRB(0, 0, 32, 0)
                      : const EdgeInsets.fromLTRB(32, 0, 0, 0),
                ),
                // focusNode: focus2,
                // onFieldSubmitted: () {
                //   SystemChannels.textInput
                //       .invokeMethod<dynamic>('TextInput.hide');
                // },
                validator: (String value) {
                  // print("==== $value");
                  // if (mobileNoController.text.isEmpty) {
                  //   return "please enter your mobile Number";
                  // } else
                  return "dfgsdf";

                  // return validationMap['phone'];
                },
              ),
               
                 Padding(
                  padding: const EdgeInsets.fromLTRB(60, 30, 60, 10),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.orange)),
                      onPressed: () {
                        verifyanewPhone();
                      },
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      child: bolc.returnchild(trans(context, 'send_code')))),
                      
              pinCode(bolc),
              const SizedBox(height: 15),
              if (enabeld)
                CircularPercentIndicator(
                    radius: 130.0,
                    progressColor: Colors.orange[300],
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 31500,
                    lineWidth: 5.0,
                    percent: 1,
                    center: Countdown(
                        build: (BuildContext c, double d) {
                          return Text("${d.truncate()}",
                              style: styles.mystyle2);
                        },
                        seconds: 30))
              else
                Container(),
             
           
              const SizedBox(height: 15),
              Text(trans(context, 'code_not_recieved'),
                  textAlign: TextAlign.center, style: styles.underHead),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.black)),
                  color: Colors.white,
                  textColor: Colors.orange,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () {},
                  child: Text(
                    trans(context, 'resend_code'),
                    style: styles.resend,
                  ),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: Divider(color: Colors.black)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      trans(context, 'problem_in_verifying'),
                      style: styles.mystyle,
                    ),
                  ),
                  ButtonToUse(
                    trans(context, 'tech_support'),
                    fw: FontWeight.bold,
                    fc: Colors.green,
                    myfunc: () {},
                  ),
                ],
              ),
            ])));
  }

  void _onCountryChange(CountryCode countryCode) {
    final MainProvider bolc = Provider.of<MainProvider>(context);
bolc.saveCountryCode(countryCode.code,countryCode.dialCode);
  

    setState(() {
      countryCodeTemp = countryCode.dialCode;
    });

    FocusScope.of(context).requestFocus(FocusNode());
  }

  void verifyanewPhone() {
    if (_formKey.currentState.validate()) {
    } else {
      print(" == ${mobileNoController.text}");

      dio.put<dynamic>("update_phone", queryParameters: <String, dynamic>{
        "password": passwordController.text,
        "new_phone": countryCodeTemp + mobileNoController.text
      }).then((Response<dynamic> value) {
        if (value.statusCode == 422) {
          value.data['errors'].forEach((String k, dynamic vv) {
            setState(() {
              validationMap[k] = vv[0].toString();
            });
            print(validationMap);
          });
          _formKey.currentState.validate();
          validationMap.updateAll((String key, String value) {
            return null;
          });
        }
        if (value.statusCode == 200) {
          setState(() {
            enabeld = true;
          });
          data.setData("phone", countryCodeTemp + mobileNoController.text);
        }
        print(value.data);
      });
    }
  }
}
