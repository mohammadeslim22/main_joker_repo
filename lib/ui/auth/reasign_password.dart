import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/util/data.dart';
import '../widgets/text_form_input.dart';
import 'package:joker/util/dio.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

class ResetPassword extends StatefulWidget {
  @override
  _MyResetPasswordState createState() => _MyResetPasswordState();
}

class _MyResetPasswordState extends State<ResetPassword>
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
                  child: const Text('Cancel')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes')),
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
                text: trans(context, 'old_password'),
                cController: usernameController,
                prefixIcon: Icons.lock_outline,
                kt: TextInputType.emailAddress,
                obscureText: false,
                readOnly: false,
                onTab: () {},
                nextfocusNode: focus1,
                onFieldSubmitted: () {
                  focus1.requestFocus();
                },
                validator: (String value) {
                  return "please enter a mobile number ";
                }),
            TextFormInput(
                text: trans(context, 'new_password'),
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
                  return "please enter your password ";
                }),
                   TextFormInput(
                text: trans(context, 'new_password'),
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

    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(shrinkWrap: true, children: <Widget>[
            Column(
              children: <Widget>[
                Text(trans(context, 'hello'), style: styles.mystyle2),
                const SizedBox(height: 10),
                Text(trans(context, 'enter old & new password'),
                    style: styles.mystyle),
                customcard(context),
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
                                  (dynamic auth) => dio.options.headers.update(
                                      'authorization',
                                      (dynamic value) async => auth));
                              Navigator.pushNamed(
                                context,
                                '/login',
                              );
                            }
                          });
                          bolc.togelf(false);
                        }
                      },
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      child: bolc.returnchild(trans(context, 'restore'))),
                ),
              ],
            ),
          ]),
        ));
  }
}
