import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/util/service_locator.dart';
import '../widgets/text_form_input.dart';
import 'package:provider/provider.dart';
import 'package:joker/util/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

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
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController newpasswordController2 = TextEditingController();
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
        child: Consumer<Auth>(
          builder: (BuildContext context, Auth auth, Widget child) {
            return Column(
              children: <Widget>[
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
                      if (value.length < 3) {
                        return "username must be more than 3 letters";
                      }
                      return auth.resetPassValidationMap['password'];
                    }),
                TextFormInput(
                    text: trans(context, 'new_password'),
                    cController: newpasswordController2,
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
                    focusNode: focus2,
                    validator: (String value) {
                      if (value.length < 3) {
                        return "username must be more than 3 letters";
                      }
                      return auth.resetPassValidationMap['password'];
                    }),
              ],
            );
          },
        ),
      ),
    );
  }

  final bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);

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
                Text(trans(context, 'enter_old_new_password'),
                    style: styles.mystyle),
                customcard(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: colors.orange)),
                          onPrimary: Colors.deepPurpleAccent,
                          textStyle: const TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_isButtonEnabled) {
                          if (newpasswordController.text.trim() !=
                              newpasswordController2.text.trim()) {
                            showToast('Passwords does not match',
                                context: context,
                                textStyle: styles.underHeadblack,
                                animation: StyledToastAnimation.slideFromTop,
                                reverseAnimation: StyledToastAnimation.fade,
                                position: StyledToastPosition.top,
                                animDuration: const Duration(seconds: 1),
                                duration: const Duration(seconds: 2),
                                curve: Curves.elasticOut,
                                backgroundColor: colors.orange,
                                reverseCurve: Curves.decelerate);
                          } else {
                            if (_formKey.currentState.validate()) {
                              final String phone = await data.getData("phone");
                              bolc.togelfResetPass(true);
                              if (await getIt<Auth>().resetpassword(
                                  phone, newpasswordController.text)) {
                                AwesomeDialog(
                                    context: context,
                                    animType: AnimType.TOPSLIDE,
                                    headerAnimationLoop: false,
                                    dialogType: DialogType.SUCCES,
                                    title: trans(context, 'success'),
                                    desc: trans(context,
                                        'password_has_changed_successfully'),
                                    btnOkOnPress: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/login', (_) => false);
                                    },
                                    btnOkIcon: Icons.check_circle,
                                    onDissmissCallback: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/login', (_) => false);
                                    }).show();
                              } else {
                                _formKey.currentState.validate();
                              }
                              getIt<Auth>()
                                  .resetPassValidationMap
                                  .updateAll((String key, String value) {
                                return null;
                              });

                              bolc.togelfResetPass(false);
                            }
                          }
                        }
                      },
                      child:
                          bolc.returnchildResetPass(trans(context, 'restore'))),
                ),
              ],
            ),
          ]),
        ));
  }
}
