import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import '../widgets/text_form_input.dart';
import 'package:joker/util/dio.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
        child: Column(
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
                  return null;
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
                focusNode: focus1,
                validator: (String value) {
                  if (value.length < 3) {
                    return "username must be more than 3 letters";
                  }
                  return null;
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
                        AwesomeDialog(
                            context: context,
                            animType: AnimType.TOPSLIDE,
                            headerAnimationLoop: false,
                            dialogType: DialogType.SUCCES,
                            title: 'Succes',
                            desc:
                                'Dialog description here..................................................',
                            btnOkOnPress: () {
                              debugPrint('OnClcik');
                            },
                            btnOkIcon: Icons.check_circle,
                            onDissmissCallback: () {
                              debugPrint('Dialog Dissmiss from callback');
                            }).show();
                        if (_formKey.currentState.validate()) {
                          final String phone = await data.getData('phone');
                          bolc.togelf(true);
                          await dio.post<dynamic>("resetpassword",
                              data: <String, dynamic>{
                                'phone': phone,
                                'password': newpasswordController.text.trim()
                              }).then((Response<dynamic> value) async {
                            print(value);
                            if (value.statusCode == 200) {
                              // showGeneralDialog<dynamic>(
                              //   barrierLabel: "Label",
                              //   barrierDismissible: true,
                              //   barrierColor: Colors.black.withOpacity(0.73),
                              //   transitionDuration:
                              //       const Duration(milliseconds: 350),
                              //   context: context,
                              //   pageBuilder: (BuildContext context,
                              //       Animation<double> anim1,
                              //       Animation<double> anim2) {
                              //     return Align(
                              //       alignment: Alignment.bottomCenter,
                              //       child: Container(
                              //         height: 400,
                              //         margin: const EdgeInsets.only(
                              //             bottom: 160, left: 12, right: 12),
                              //         decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius: BorderRadius.circular(40),
                              //         ),
                              //         child: Material(
                              //           type: MaterialType.transparency,
                              //           child: SizedBox.expand(
                              //             child: Column(
                              //               children: <Widget>[
                              //                 SvgPicture.asset(
                              //                     'assets/images/checkdone.svg'),
                              //                 const SizedBox(height: 15),
                              //                 Text(
                              //                   trans(context,
                              //                       "password_edited_successfully"),
                              //                   style: styles.underHeadblack,
                              //                 )
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   transitionBuilder: (BuildContext context,
                              //       Animation<double> anim1,
                              //       Animation<double> anim2,
                              //       Widget child) {
                              //     return SlideTransition(
                              //       position: Tween<Offset>(
                              //               begin: const Offset(0, 1),
                              //               end: const Offset(0, 0))
                              //           .animate(anim1),
                              //       child: child,
                              //     );
                              //   },
                              // );
                              Navigator.pushNamed(context, '/login');
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
