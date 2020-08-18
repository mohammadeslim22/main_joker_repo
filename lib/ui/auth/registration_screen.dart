import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/providers/auth.dart';
import '../widgets/buttonTouse.dart';
import '../widgets/text_form_input.dart';
import 'package:location/location.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/functions.dart';

class Registration extends StatefulWidget {
  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  List<String> location2;
  Location location = Location();

  bool _isButtonEnabled;

  bool _obscureText = false;
  bool loading = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  static DateTime today = DateTime.now();
  String countryCodeTemp = "+90";
  DateTime firstDate = DateTime(today.year - 90, today.month, today.day);
  DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isButtonEnabled = true;
    data.getData("countryDialCodeTemp").then((String value) {
      setState(() {
        countryCodeTemp = value;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: lastDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null && picked != today)
      setState(() {
        today = picked;
        birthDateController.text = intl.DateFormat('yyyy-MM-dd').format(picked);
        FocusScope.of(context).requestFocus(FocusNode());
      });
    if (picked == null || picked != today)
      FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget customcard(
      BuildContext context, MainProvider mainProvider, Auth auth) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final FocusNode focus = FocusNode();
    final FocusNode focusminus1 = FocusNode();
    final FocusNode focus1 = FocusNode();
    final FocusNode focus2 = FocusNode();
    final FocusNode focus3 = FocusNode();
    final FocusNode focus4 = FocusNode();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: Form(
            key: _formKey,
            onWillPop: () {
              return onWillPop(context);
            },
            child: Column(children: <Widget>[
              TextFormInput(
                  text: trans(context, 'name'),
                  cController: usernameController,
                  prefixIcon: Icons.person_outline,
                  kt: TextInputType.visiblePassword,
                  obscureText: false,
                  focusNode: focusminus1,
                  readOnly: false,
                  onFieldSubmitted: () {
                    focus.requestFocus();
                  },
                  onTab: () {
                    focusminus1.requestFocus();
                  },
                  validator: (String value) {
                    if (value.length < 3) {
                      return trans(context, 'username_more_than_3');
                    }
                    return auth.regValidationMap['name'];
                  }),
                 // 0595388810
              TextFormInput(
                  text: trans(context, 'email'),
                  cController: emailController,
                  prefixIcon: Icons.mail_outline,
                  kt: TextInputType.emailAddress,
                  obscureText: false,
                  readOnly: false,
                  focusNode: focus,
                  onTab: () {
                    focus.requestFocus();
                  },
                  onFieldSubmitted: () {
                    focus1.requestFocus();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_valid_email');
                    }
                    return auth.regValidationMap['email'];
                  }),
              TextFormInput(
                  text: trans(context, 'mobile_no'),
                  cController: mobileNoController,
                  prefixIcon: Icons.phone,
                  kt: TextInputType.phone,
                  obscureText: false,
                  readOnly: false,
                  onTab: () {},
                  suffixicon: CountryCodePicker(
                    onChanged: _onCountryChange,
                    initialSelection:'IL',
                    favorite: <String>[mainProvider.dialCodeFav],
                    showFlagDialog: true,
                    showFlag: false,
                    padding: isRTL == true
                        ? const EdgeInsets.fromLTRB(0, 0, 32, 0)
                        : const EdgeInsets.fromLTRB(32, 0, 0, 0),
                  ),
                  focusNode: focus1,
                  onFieldSubmitted: () {
                    focus2.requestFocus();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_valid_email');
                    }
                    return auth.regValidationMap['phone'];
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
                  obscureText: _obscureText,
                  focusNode: focus2,
                  validator: (String value) {
                    if (passwordController.text.length < 6) {
                      return trans(context, 'pass_must_more_6');
                    }
                    return auth.regValidationMap['password'];
                  }),
              TextFormInput(
                  text: trans(context, 'birth_date'),
                  cController: birthDateController,
                  prefixIcon: Icons.date_range,
                  kt: TextInputType.visiblePassword,
                  obscureText: false,
                  readOnly: true,
                  onTab: () {
                    _selectDate(context);
                  },
                  suffixicon:
                      // IconButton(
                      // color: Colors.orange,
                      // icon:
                      Icon(
                    Icons.calendar_today,
                  ),
                  // onPressed: () {},
                  // ),
                  focusNode: focus3,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_birthdate');
                    }
                    return auth.regValidationMap['birthdate'];
                  }),
              TextFormInput(
                  text: trans(context, 'get_location'),
                  cController: config.locationController,
                  prefixIcon: Icons.my_location,
                  kt: TextInputType.visiblePassword,
                  readOnly: true,
                  onTab: () async {
                    try {
                      mainProvider.togelocationloading(true);
                      if (await updateLocation) {
                        await getLocationName();
                        mainProvider.togelocationloading(false);
                      } else {
                        Vibration.vibrate(duration: 400);
                        mainProvider.togelocationloading(false);

                        Scaffold.of(context).showSnackBar(snackBar);
                        setState(() {
                          config.locationController.text =
                              trans(context, 'tab_set_ur_location');
                        });
                      }
                    } catch (e) {
                      Vibration.vibrate(duration: 400);
                      mainProvider.togelocationloading(false);
                      Scaffold.of(context).showSnackBar(snackBar);
                      setState(() {
                        config.locationController.text =
                            trans(context, 'tab_set_ur_location');
                      });
                    }
                  },
                  suffixicon: IconButton(
                    icon: Icon(Icons.add_location, color: Colors.orange),
                    onPressed: () {
                      Navigator.pushNamed(context, '/AutoLocate',
                          arguments: <String, double>{
                            "lat": 51.0,
                            "long": 9.6
                          });
                    },
                  ),
                  obscureText: false,
                  focusNode: focus4,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_set_ur_location');
                    }
                    return auth.regValidationMap['location'];
                  }),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: mainProvider.visibilityObs
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: spinkit,
                          ),
                        ],
                      )
                    : Container(),
              )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);
    final Auth auth = Provider.of<Auth>(context);
    return Scaffold(
        appBar: AppBar(),
        body: Builder(
            builder: (BuildContext context) => GestureDetector(
                  onTap: () {
                    SystemChannels.textInput
                        .invokeMethod<String>('TextInput.hide');
                  },
                  child: ListView(
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Text(trans(context, 'account_creation'),
                          textAlign: TextAlign.center, style: styles.mystyle2),
                      const SizedBox(height: 8),
                      Text(trans(context, 'please_check'),
                          textAlign: TextAlign.center,
                          style: styles.pleazeCheck),
                      customcard(context, mainProvider, auth),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.orange)),
                            onPressed: () async {
                              if (_isButtonEnabled) {
                                if (_formKey.currentState.validate()) {
                                  mainProvider.togelf(true);
                                  setState(() {
                                    _isButtonEnabled = false;
                                  });
                                  await auth.register(
                                      context,
                                      mainProvider,
                                      usernameController.text,
                                      passwordController.text,
                                      birthDateController.text,
                                      emailController.text,
                                      mobileNoController.text,
                                      countryCodeTemp);

                                  _formKey.currentState.validate();
                                }
                              }
                            },
                            color: Colors.deepOrangeAccent,
                            textColor: colors.white,
                            child: mainProvider
                                .returnchild(trans(context, 'regisration'))),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                )));
  }

  void _onCountryChange(CountryCode countryCode) {
    final MainProvider bolc = Provider.of<MainProvider>(context);
    bolc.saveCountryCode(countryCode.code, countryCode.dialCode);

    setState(() {
      countryCodeTemp = countryCode.dialCode;
    });

    FocusScope.of(context).requestFocus(FocusNode());
  }
}
