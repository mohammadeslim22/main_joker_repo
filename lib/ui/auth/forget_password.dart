import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/text_form_input.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _MyForgetPassState createState() => _MyForgetPassState();
}

class _MyForgetPassState extends State<ForgetPassword>
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

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
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
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(trans(context, 'reset_password'),
                          style: styles.mystyle2),
                      const SizedBox(height: 10),
                      Text(trans(context, 'enter_mobile_no'),
                          style: styles.mystyle),
                      const SizedBox(height: 30),
                      TextFormInput(
                          text: trans(context, 'mobile_number'),
                          cController: usernameController,
                          prefixIcon: Icons.settings_phone,
                          kt: TextInputType.phone,
                          obscureText: false,
                          readOnly: false,
                          onTab: () {},
                          nextfocusNode: focus1,
                          onFieldSubmitted: () {
                            focus1.requestFocus();
                          },
                          validator: (String value) {
                            return "please enter your email ";
                          }),
                      SafeArea(
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
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
                                    bolc.togelf(true);
                                    if (true) {
                                      Navigator.pushNamed(
                                          context, '/Reset_pass');
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
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: colors.orange)),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                bolc.togelf(true);

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
          )),
    );
  }
}
