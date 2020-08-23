import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/functions.dart';
import '../widgets/text_form_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/buttonTouse.dart';
import 'package:country_code_picker/country_code_picker.dart';
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

  String countryCodeTemp = "+90";

  @override
  void initState() {
    super.initState();
    data.getData("countryDialCodeTemp").then((String value) {
      setState(() {
        countryCodeTemp = value;
      });
    });
  }

  Widget customcard(BuildContext context,
      {MainProvider mainProvider, Auth auht, bool isRTL}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Form(
        key: _formKey,
        onWillPop: () {
          return onWillPop(context);
        },
        child: Column(
          children: <Widget>[
            TextFormInput(
              text: trans(context, 'mobile_no'),
              cController: _usernameController,
              prefixIcon: Icons.phone,
              kt: TextInputType.phone,
              obscureText: false,
              readOnly: false,
              suffixicon: CountryPickerCode(
                  onCountryChange: _onCountryChange, isRTL: isRTL),
              // CountryCodePicker(
              //   onChanged: _onCountryChange,
              //   initialSelection: mainProvider.dialCodeFav,
              //   favorite: const <String>['+39', 'FR'],
              //   showFlagDialog: true,
              //   showFlag: false,
              //   padding: isRTL == true
              //       ? const EdgeInsets.fromLTRB(0, 0, 32, 0)
              //       : const EdgeInsets.fromLTRB(32, 0, 0, 0),
              // ),
              onFieldSubmitted: () {
                _focus1.requestFocus();
              },
              validator: (String value) {
                if (value.isEmpty) {
                  return trans(context, 'p_enter_u_mobile');
                }
                return auht.validationMap['phone'];
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
                return auht.validationMap['password'];
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
    // final Auth auht = Provider.of<Auth>(context);
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(shrinkWrap: true, children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
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
                // TODO(mohammed): rename mystyle2.
                Text(trans(context, 'joker'),
                    textAlign: TextAlign.center, style: styles.mystyle2),
                const SizedBox(height: 5),
                Text(
                  trans(context, 'all_you_need'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: colors.jokerBlue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 30),
                Text(trans(context, 'hello'), style: styles.mystyle2),
                const SizedBox(height: 10),
                Text(trans(context, 'enter_login_information'),
                    style: styles.mystyle),
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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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

                            if (await auth.login(
                                countryCodeTemp,
                                _usernameController.text,
                                _passwordController.text,
                                context)) {
                            } else {
                              _formKey.currentState.validate();
                            }
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
                const SizedBox(height: 80),
                Text(trans(context, 'dont_have_account'),
                    style: styles.mystyle),
                ButtonToUse(trans(context, 'create_account'),
                    fontWait: FontWeight.bold,
                    fontColors: Colors.black,
                    width: MediaQuery.of(context).size.width, onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/Registration', (_) => false);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(trans(context, 'you_have_shop'),
                          style: styles.mystyle),
                      Expanded(
                        child: ButtonToUse(
                          trans(context, 'click_here'),
                          fontWait: FontWeight.bold,
                          fontColors: colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ]),
    ));
  }

  void _onCountryChange(CountryCode countryCode) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);
    mainProvider.saveCountryCode(countryCode.code, countryCode.dialCode);
    setState(() {
      countryCodeTemp = countryCode.dialCode;
    });

    FocusScope.of(context).requestFocus(FocusNode());
  }
}
