import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/ui/widgets/countryCodePicker.dart';
import '../widgets/buttonTouse.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:joker/constants/colors.dart';
import '../widgets/text_form_input.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class PinCode extends StatefulWidget {
  const PinCode({Key key, this.mobileNo}) : super(key: key);
  final String mobileNo;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PinCode> with TickerProviderStateMixin {
  AnimationController controller;
  String currentText = "0000";
  bool showTimer = true;
  bool buttonChangeMoEnabeld = true;
  final TextEditingController mobileNoController = TextEditingController();
  PersistentBottomSheetController<dynamic> bottomSheetController;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
  }

  Widget pinCode(MainProvider bolc, Auth auth) {
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
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 160,
              child: PinCodeTextField(
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                keyboardType: TextInputType.phone,
                onCompleted: (String v) async {
                  bolc.togelf(true);
                  if (await auth.getPinCode(v.trim())) {
                    Navigator.pushNamed(context, '/login');
                  }
                  bolc.togelf(false);
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

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(),
        body: GestureDetector(onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        }, child: Consumer<Auth>(
          builder: (BuildContext context, Auth auth, Widget child) {
            return ListView(children: <Widget>[
              const SizedBox(height: 20),
              Text(trans(context, 'pin_code'),
                  textAlign: TextAlign.center, style: styles.mystyle2),
              const SizedBox(height: 15),
              Text(trans(context, 'pin_has_been_sent'),
                  textAlign: TextAlign.center, style: styles.underHead),
              const SizedBox(height: 15),
              Text("${widget.mobileNo}",
                  textAlign: TextAlign.center, style: styles.pinCodePhone),
              Container(
                alignment: Alignment.center,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(trans(context, 'change_phone_while_regestrating')),
                    ],
                  ),
                  onTap: () {
                    if (buttonChangeMoEnabeld) {
                      final FocusNode focus1 = FocusNode();
                      final bool isRTL =
                          Directionality.of(context) == TextDirection.rtl;
                      bottomSheetController =
                          _scaffoldkey.currentState.showBottomSheet<dynamic>(
                        (BuildContext context) {
                          focus1.requestFocus();
                          return Container(
                            height: 290,
                            padding: const EdgeInsets.all(32.0),
                            color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                Text(trans(context, 'enter_new_mobile')),
                                const SizedBox(height: 24),
                                TextFormInput(
                                    text: trans(context, 'mobile_no'),
                                    cController: mobileNoController,
                                    prefixIcon: Icons.phone,
                                    kt: TextInputType.phone,
                                    obscureText: false,
                                    readOnly: false,
                                    onTab: () {},
                                    suffixicon: CountryPickerCode(
                                        context: context, isRTL: isRTL),
                                    focusNode: focus1,
                                    onFieldSubmitted: () async {
                                      if (await auth.sendPinNewPhone(
                                          mobileNoController.text, context)) {
                                        setState(() {
                                          buttonChangeMoEnabeld = false;
                                        });
                                      }
                                    },
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "please enter your mobile Number  ";
                                      }
                                      return trans(context, 'p_enter_u_mobile');
                                    }),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 30, 20, 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: colors.orange)),
                                            onPrimary: Colors.deepPurpleAccent,
                                            textStyle:
                                                TextStyle(color: colors.white)),
                                        onPressed: () async {
                                          if (await auth.sendPinNewPhone(
                                              mobileNoController.text,
                                              context)) {
                                            setState(() {
                                              buttonChangeMoEnabeld = false;
                                            });
                                          }
                                        },
                                        child: bolc.returnchild(
                                            trans(context, 'send_code')))),
                              ],
                            ),
                          );
                        },
                      );
                      bottomSheetController.closed.then((dynamic value) {
                        //  sendPinNewPhone(mobileNoController.text);
                      });
                    } else {
                      showToast(trans(context, 'you_can_change_mo_only_once'),
                          context: context,
                          textStyle: styles.underHeadblack,
                          animation: StyledToastAnimation.scale,
                          reverseAnimation: StyledToastAnimation.fade,
                          position: StyledToastPosition.center,
                          animDuration: const Duration(seconds: 1),
                          duration: const Duration(seconds: 4),
                          curve: Curves.elasticOut,
                          backgroundColor: colors.white,
                          reverseCurve: Curves.decelerate);
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              pinCode(bolc, auth),
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
                        return Text("${d.truncate()}", style: styles.mystyle2);
                      },
                      seconds: 30)),
              const SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.fromLTRB(60, 30, 60, 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.orange)),
                          onPrimary: Colors.deepPurpleAccent,
                          textStyle: const TextStyle(color: Colors.white)),
                      onPressed: () {},
                      child: bolc.returnchild(trans(context, 'aprove')))),
              const SizedBox(height: 15),
              Text(trans(context, 'code_not_recieved'),
                  textAlign: TextAlign.center, style: styles.underHead),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.black)),
                    onPrimary: Colors.white,
                    textStyle: TextStyle(color: colors.orange),
                    padding: const EdgeInsets.all(8.0),
                  ),
                  onPressed: () async {
                    if (await auth.sendPinNewPhone(
                        mobileNoController.text, context)) {
                      setState(() {
                        buttonChangeMoEnabeld = false;
                      });
                    }
                  },
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
                      trans(context, 'problem_in_regisration'),
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
            ]);
          },
        )));
  }
}
