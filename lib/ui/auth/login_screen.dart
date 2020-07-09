import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/util/data.dart';
import '../widgets/text_form_input.dart';
import 'package:joker/util/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/buttonTouse.dart';
import 'package:dio/dio.dart';
import '../widgets/custom_toast_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
//import 'package:joker/providers/language.dart';
//import 'package:joker/constants/config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isButtonEnabled = true;
  static List<String> validators = <String>[null, null];
  static List<String> keys = <String>[
    'phone',
    'password',
  ];

  Map<String, String> validationMap =
      Map<String, String>.fromIterables(keys, validators);
  String countryCodeTemp = "+90";
    String countryCode = "TR";

  @override
  void initState() {
    super.initState();
    data.getData("countryCodeTemp").then((String value) {
      setState(() {
        countryCode = value;
      });
    });
  }

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

  bool _obscureText = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  Widget customcard(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Form(
        key: _formKey,
        onWillPop: () {
          return _onWillPop();
        },
        child: Column(
          children: <Widget>[
            TextFormInput(
                text: trans(context, 'mobile_no'),
                cController: usernameController,
                prefixIcon: Icons.phone,
                kt: TextInputType.phone,
                obscureText: false,
                readOnly: false,
                onTab: () {},
                suffixicon: CountryCodePicker(
                  onChanged: _onCountryChange,
                  initialSelection: countryCode,
                  favorite: const <String>['+90', 'TR'],
                  showFlagDialog: true,
                  showFlag: false,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: isRTL == true
                      ? const EdgeInsets.fromLTRB(0, 0, 32, 0)
                      : const EdgeInsets.fromLTRB(32, 0, 0, 0),
                ),
                onFieldSubmitted: () {
                  focus1.requestFocus();
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return "please enter your mobile Number  ";
                  }
                  return validationMap['phone'];
                }),
            // TextFormInput(
            //     text: trans(context, 'mobile_no'),
            //     cController: usernameController,
            //     prefixIcon: Icons.phone,
            //     kt: TextInputType.phone,
            //     obscureText: false,
            //     readOnly: false,
            //     onTab: () {},
            //     nextfocusNode: focus1,
            //     onFieldSubmitted: () {
            //       focus1.requestFocus();
            //     },
            //     validator: (String value) {
            //       if (value.isEmpty) {
            //         return "please enter a mobile number ";
            //       }
            //       return validationMap['phone'];
            //     }),
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
                onFieldSubmitted: () {
                  focus2.requestFocus();
                },
                obscureText: _obscureText,
                focusNode: focus1,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "please enter your password ";
                  }
                  return validationMap['password'];
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MinProvider bolc = Provider.of<MinProvider>(context);
    //final Language lang = Provider.of<Language>(context);

    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(shrinkWrap: true, children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 120.0,
            height: 120.0,
          ),
        ),
        Column(
          children: <Widget>[
            Text(trans(context, 'joker'),
                textAlign: TextAlign.center, style: styles.mystyle2),
            const SizedBox(height: 5),
            Text(trans(context, 'all_you_need'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: colors.orange,
                    fontSize: 20)),
            const SizedBox(height: 50),
            Text(trans(context, 'hello'), style: styles.mystyle2),
            const SizedBox(height: 10),
            Text(trans(context, 'enter_login_information'),
                style: styles.mystyle),
            customcard(context),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
              child: ButtonToUse(
                trans(context, 'forget_password'),
                fw: FontWeight.w500,
                fc: colors.black,
                myfunc: () {
                  Navigator.pushNamed(context, '/forget_pass');
                },
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
                        bolc.togelf(true);
                        setState(() {
                          _isButtonEnabled = false;
                        });
                        await dio
                            .post<dynamic>("login", data: <String, dynamic>{
                          "phone": countryCodeTemp +
                              usernameController.text.toString().trim(),
                          "password": passwordController.text.toString()
                        }).then((Response<dynamic> value) async {
                          print(value.data);
                          setState(() {
                            _isButtonEnabled = true;
                          });
                          if (value.statusCode == 422) {
                            value.data['errors']
                                .forEach((String k, dynamic vv) {
                              setState(() {
                                validationMap[k] = vv[0].toString();
                              });
                              print(validationMap);
                            });
                            _formKey.currentState.validate();
                            validationMap.updateAll((String key, String value) {
                              return null;
                            });
                            print(validationMap);
                          }

                          if (value.statusCode == 200) {
                            if (value.data != "fail") {
                              await data.setData("authorization",
                                  "Bearer ${value.data['api_token']}");
                              dio.options.headers['authorization'] =
                                  'Bearer ${value.data['api_token']}';

                              // data.getData("lang").then((String value) async {
                              //   print("1: $value");
                              //   config.userLnag = Locale(value);
                              //   await lang.setLanguage(Locale(value));
                              //   print("2: ${lang.currentLanguage}");
                              // });

                              print(dio.options.headers);
                              Navigator.pushNamed(context, '/Home',
                                  arguments: <String, dynamic>{
                                    "salesDataFilter": false,
                                    "FilterData": null
                                  });
                            } else {
                              showToastWidget(
                                  IconToastWidget.fail(
                                      msg:
                                          trans(context, 'wrong_user_or_pass')),
                                  context: context,
                                  position: StyledToastPosition.center,
                                  animation: StyledToastAnimation.scale,
                                  reverseAnimation: StyledToastAnimation.fade,
                                  duration: const Duration(seconds: 4),
                                  animDuration: const Duration(seconds: 1),
                                  curve: Curves.elasticOut,
                                  reverseCurve: Curves.linear);
                            }
                          }
                        });
                        bolc.togelf(false);
                      }
                    }
                  },
                  color: Colors.deepOrangeAccent,
                  textColor: Colors.white,
                  child: bolc.returnchild(trans(context, 'login'))),
            ),
            const SizedBox(height: 80),
            Text(trans(context, 'dont_have_account'), style: styles.mystyle),
            ButtonToUse(trans(context, 'create_account'),
                fw: FontWeight.bold,
                fc: Colors.black,
                width: MediaQuery.of(context).size.width, myfunc: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Registration', (_) => false);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(trans(context, 'you_have_shop_'), style: styles.mystyle),
                  Expanded(
                    child: ButtonToUse(
                      trans(context, 'click_here'),
                      fw: FontWeight.bold,
                      fc: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    ));
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {

      countryCodeTemp = countryCode.dialCode;
    });

    FocusScope.of(context).requestFocus(FocusNode());
  }
}
