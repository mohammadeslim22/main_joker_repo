import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/ui/widgets/text_form_input.dart';
import 'package:joker/util/service_locator.dart';
import '../widgets/buttonTouse.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/ui/widgets/country_code_picker.dart';

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
  }

  bool enabeld = false;
  Widget pinCode(MainProvider bolc) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
              width: 170,
              child: PinCodeTextField(
                enabled: enabeld,
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                // shape: PinCodeFieldShape.box,
                // borderRadius: BorderRadius.circular(5),
                // inactiveColor: Colors.grey,
                // fieldHeight: 40,
                // fieldWidth: 30,
                keyboardType: TextInputType.phone,
                onCompleted: (String v) async {
                  bolc.togelfPinCodeProfile(true);
                  if (await getIt<Auth>()
                      .getPinCodeSave(v.trim(), mobileNoController.text) != null) {
                    setState(() {
                      config.prifleNoVerfiyDone = true;
                    });
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/Profile');
                  }
                  bolc.togelfPinCodeProfile(false);
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
    );
  }

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController mobileNoController = TextEditingController();
  bool _obscureText = false;
  final FocusNode focus = FocusNode();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 18,
                  )),
              Text(trans(context, 'enter_your_pass_s_u_can_change_phone'),
                  textAlign: TextAlign.center, style: styles.underHead),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Consumer<Auth>(
                  builder: (BuildContext context, Auth auth, Widget child) {
                    return Column(
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
                                return trans(context, "pass_must_more_6");
                              }
                              return auth
                                  .pinCodeProfileValidationMap['password'];
                            }),
                        TextFormInput(
                          text: trans(context, 'new_mobile_no'),
                          cController: mobileNoController,
                          prefixIcon: Icons.phone,
                          kt: TextInputType.phone,
                          onTab: () {},
                          obscureText: false,
                          readOnly: false,
                          suffixicon:
                              CountryPickerCode(context: context, isRTL: isRTL),
                          validator: (String value) {
                            if (mobileNoController.text.isEmpty) {
                              return trans(context, 'p_enter_u_mobile');
                            } else
                              return auth.pinCodeProfileValidationMap['phone'];
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(60, 30, 60, 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                  color: Colors.deepPurpleAccent)),
                          onPrimary: Colors.deepPurpleAccent,
                          textStyle: TextStyle(color: colors.white)),
                      onPressed: () async{
                      await  verifyanewPhone();
                      },
                      child: bolc.returnchildPinforProfile(trans(context, 'send_code')))),
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
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.black)),
                    onPrimary: colors.white,
                    textStyle: TextStyle(color: colors.orange),
                    padding: const EdgeInsets.all(8.0),
                  ),
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
                    fontWait: FontWeight.bold,
                    fontColors: Colors.green,
                    onPressed: () {},
                  ),
                ],
              ),
            ])));
  }

  Future<void> verifyanewPhone() async {
    if (_formKey.currentState.validate()) {
        await  getIt<Auth>()
          .verifyNewPhone(passwordController.text, mobileNoController.text)
          .then((bool value) {
        _formKey.currentState.validate();
        if (value) {
          setState(() {
            enabeld = true;
          });
        }
      });
      getIt<Auth>()
          .pinCodeProfileValidationMap
          .updateAll((String key, String value) {
        return null;
      });
    } else {
  
    }
  }
}
