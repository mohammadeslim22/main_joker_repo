import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

class LoginScreen extends StatefulWidget {
  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
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
                nextfocusNode: focus1,
                onFieldSubmitted: () {
                  focus1.requestFocus();
                },
                validator: () {
                  return "please enter a mobile number ";
                }),
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
                validator: () {
                  return "please enter your password ";
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MyCounter bolc = Provider.of<MyCounter>(context);
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: ListView(shrinkWrap: true, children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
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
                        fontSize: 20,
                      )),
                  const SizedBox(height: 50),
                  Text(trans(context, 'hello'), style: styles.mystyle2),
                  const SizedBox(height: 10),
                  Text(trans(context, 'enter_login_information'),
                      style: styles.mystyle),
                  customcard(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Container(
                      alignment:
                          isRTL ? Alignment.centerLeft : Alignment.centerRight,
                      child: ButtonToUse(trans(context, 'forget_password'),
                          fw: FontWeight.w500, fc: colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: colors.orange)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            bolc.togelf(true);
                            await dio
                                .post<dynamic>("login", data: <String, String>{
                              "phone": usernameController.text.toString(),
                              "password": passwordController.text.toString()
                            }).then((Response<dynamic> value) async {
                              print(value);
                              if (value.statusCode == 200) {
                               await data.setData("authorization",
                                    "Bearer ${value.data['api_token']}");
                                data.getData('authorization').then<dynamic>(
                                    (dynamic auth) => dio.options.headers
                                        .update('authorization',
                                            (dynamic value) async => auth));
                                print(
                                    " are u fucken stupid ?${dio.options.headers.entries.last.value}");

                               print(  "are u fucken stupid again?${dio.options.headers.putIfAbsent('Authorization',
                                    () =>"Bearer ${value.data['api_token']}")}");

                                print(dio.options.headers);
                                Navigator.pushNamed(
                                  context,
                                  '/Home',
                                );
                              }
                            });
                            bolc.togelf(false);
                          }
                        },
                        color: Colors.deepOrangeAccent,
                        textColor: Colors.white,
                        child: bolc.returnchild(trans(context, 'login'))),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    trans(context, 'dont_have_account'),
                    style: styles.mystyle,
                  ),
                  ButtonToUse(trans(context, 'create_account'),
                      fw: FontWeight.bold,
                      fc: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      myfunc: () =>
                          Navigator.pushNamed(context, '/Registration')),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          trans(context, 'you_have_shop_'),
                          style: styles.mystyle,
                        ),
                        ButtonToUse(
                          trans(context, 'click_here'),
                          fw: FontWeight.bold,
                          fc: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
