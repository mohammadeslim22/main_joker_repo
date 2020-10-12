import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/util/functions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/text_form_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/buttonTouse.dart';
import 'package:joker/ui/widgets/countryCodePicker.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isButtonEnabled = true;
  bool _obscureText = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focus1 = FocusNode();
  final FocusNode _focus2 = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  Widget customcard(BuildContext context,
      {MainProvider mainProvider, Auth auht, bool isRTL}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Form(
        key: _formKey,
        // onWillPop: () {
        //   return null;
        //   //onWillPop(context);
        // },
        child: Column(
          children: <Widget>[
            TextFormInput(
              text: trans(context, 'mobile_no'),
              cController: _usernameController,
              prefixIcon: Icons.phone,
              kt: TextInputType.phone,
              obscureText: false,
              readOnly: false,
              suffixicon: CountryPickerCode(context: context, isRTL: isRTL),
              onFieldSubmitted: () {
                _focus1.requestFocus();
              },
              validator: (String value) {
                if (value.isEmpty) {
                  return trans(context, 'p_enter_u_mobile');
                }
                return auht.loginValidationMap['phone'];
              },
            ),
            TextFormInput(
              text: trans(context, 'password'),
              cController: _passwordController,
              prefixIcon: Icons.lock_outline,
              kt: TextInputType.visiblePassword,
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
                _focus2.requestFocus();
              },
              obscureText: _obscureText,
              focusNode: _focus1,
              validator: (String value) {
                if (value.isEmpty) {
                  return trans(context, 'p_enter_password');
                }
                return auht.loginValidationMap['password'];
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(shrinkWrap: true, children: <Widget>[
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            goToMap(context);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(trans(context, 'back_to_map')),
                const SizedBox(width: 16),
                Icon(Icons.keyboard_return, color: colors.jokerBlue)
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            "assets/images/Layer.svg",
            width: 120.0,
            height: 120.0,
          ),
        ),
        Consumer<Auth>(
          builder: (BuildContext context, Auth auth, Widget child) {
            return Column(
              children: <Widget>[
                customcard(context,
                    mainProvider: mainProvider, isRTL: isRTL, auht: auth),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  alignment:
                      isRTL ? Alignment.centerLeft : Alignment.centerRight,
                  child: ButtonToUse(
                    trans(context, 'forget_password'),
                    fontWait: FontWeight.w500,
                    fontColors: colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, '/forget_pass');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: colors.jokerBlue)),
                      onPressed: () async {
                        if (_isButtonEnabled) {
                          if (_formKey.currentState.validate()) {
                            mainProvider.togelf(true);
                            setState(() {
                              _isButtonEnabled = false;
                            });
                            if (await auth.login(_usernameController.text,
                                _passwordController.text, context)) {
                            } else {
                              _formKey.currentState.validate();
                            }
                            auth.loginValidationMap
                                .updateAll((String key, String value) {
                              return null;
                            });
                            setState(() {
                              _isButtonEnabled = true;
                            });
                            mainProvider.togelf(false);
                          }
                        }
                      },
                      color: colors.blue,
                      textColor: colors.white,
                      child: mainProvider.returnchild(trans(context, 'login'))),
                ),
                const SizedBox(height: 40),
                Text(trans(context, 'dont_have_account'),
                    style: styles.mystyle),
                ButtonToUse(trans(context, 'create_account'),
                    fontWait: FontWeight.bold,
                    fontColors: Colors.black,
                    width: MediaQuery.of(context).size.width, onPressed: () {
                  Navigator.pushNamed(context, '/Registration');
                }),
              ],
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(trans(context, 'you_have_shop'), style: styles.mystyle),
              Expanded(
                child: ButtonToUse(
                  trans(context, 'click_here'),
                  fontWait: FontWeight.bold,
                  fontColors: colors.green,
                  onPressed: () async {
                    if (await canLaunch(config.registerURL)) {
                      await launch(config.registerURL);
                    } else {
                      throw 'Could not launch ${config.registerURL}';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}
