import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/base_widget.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/ui/view_models/auth_view_models/change_password_modle.dart';
import 'package:joker/util/service_locator.dart';
import '../widgets/text_form_input.dart';
class ChangePassword extends StatefulWidget {
  @override
  _MyChangePasswordState createState() => _MyChangePasswordState();
}

class _MyChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(trans(context, "are_you_sure")),
            content: Text(trans(context, "do_u_want_to_exit")),
            actionsOverflowButtonSpacing: 50,
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(trans(context, "cancel"))),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(trans(context, "yes"))),
            ],
          ),
        )) ??
        false;
  }

  bool _obscureText = true;
  final TextEditingController oldpasswordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController newpassword2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  Widget customcard(BuildContext context, ChangePasswordModle modle) {
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
                cController: oldpasswordController,
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
                  return modle.changePassValidationMap['old_passwoed'];
                }),
            TextFormInput(
                text: trans(context, 'new_password'),
                cController: newpasswordController,
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
                  if (value.length < 6) {
                    return "password must be more than 5 letters";
                  }
                  return modle.changePassValidationMap['new_password'];
                }),
            TextFormInput(
                text: trans(context, 'new_password'),
                cController: newpassword2Controller,
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
                focusNode: focus2,
                onFieldSubmitted: () {},
                obscureText: _obscureText,
                validator: (String value) {
                  if (value.length < 6) {
                    return "password must be more than 5 letters";
                  }
                  return modle.changePassValidationMap['newpassword2'];
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ChangePasswordModle>(
        model: getIt<ChangePasswordModle>(),
        builder: (BuildContext context, ChangePasswordModle modle,
                Widget child) =>
            Scaffold(
                appBar: AppBar(),
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: ListView(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(trans(context, 'hello'), style: styles.mystyle2),
                        const SizedBox(height: 10),
                        Text(trans(context, 'enter_old_new_password'),
                            style: styles.mystyle),
                        customcard(context, modle),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: colors.orange)),
                                  onPrimary: colors.orange,
                                  textStyle: TextStyle(color: colors.white)),
                              onPressed: modle.busy
                                  ? null
                                  : () async {
                                      if (_formKey.currentState.validate()) {
                                        await modle
                                            .changePassword(
                                                oldpasswordController.text,
                                                newpasswordController.text,
                                                context)
                                            .then((bool value) {
                                          if (!value) {
                                            _formKey.currentState.validate();
                                          }
                                          modle.changePassValidationMap
                                              .updateAll(
                                                  (String key, String value) {
                                            return null;
                                          });
                                        });

                                      }
                                    },
                              child: modle.returnchildChangePass(
                                  trans(context, 'change_my_password'))),
                        ),
                      ],
                    ),
                  ]),
                )));
  }
}
