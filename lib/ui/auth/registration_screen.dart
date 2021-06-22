import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:joker/base_widget.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/ui/view_models/auth_view_models/registration_model.dart';
import 'package:joker/ui/widgets/country_code_picker.dart';
import 'package:joker/util/service_locator.dart';
import '../widgets/buttonTouse.dart';
import '../widgets/text_form_input.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/util/functions.dart';

class Registration extends StatefulWidget {
  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  List<String> location2;
  bool _obscureText = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  static DateTime today = DateTime.now();
  DateTime firstDate = DateTime(today.year - 90, today.month, today.day);
  DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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

  Widget customcard(BuildContext context, RegistrationModel modle) {
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
                    return modle.regValidationMap['name'];
                  }),
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
                    return modle.regValidationMap['email'];
                  }),
              TextFormInput(
                  text: trans(context, 'mobile_no'),
                  cController: mobileNoController,
                  prefixIcon: Icons.phone,
                  kt: TextInputType.phone,
                  obscureText: false,
                  readOnly: false,
                  onTab: () {},
                  suffixicon: CountryPickerCode(context: context, isRTL: isRTL),
                  focusNode: focus1,
                  onFieldSubmitted: () {
                    focus2.requestFocus();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_valid_email');
                    }
                    return modle.regValidationMap['phone'];
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
                      color: colors.orange,
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
                    return modle.regValidationMap['password'];
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
                  suffixicon: Icon(
                    Icons.calendar_today,
                    color: colors.orange,
                  ),
                  focusNode: focus3,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_birthdate');
                    }
                    return modle.regValidationMap['birthdate'];
                  }),
              TextFormInput(
                  text: trans(context, 'get_location'),
                  cController: locationController,
                  prefixIcon: Icons.my_location,
                  kt: TextInputType.visiblePassword,
                  readOnly: true,
                  onTab: () async {
                    try {
                      modle.togelocationloading(true);
                      final Map<String, dynamic> location =
                          await updateLocation;
                      if (location["res"] as bool) {
                        setState(() {
                          locationController.text =
                              location["address"].toString();
                        });
                      } else {
                        Vibration.vibrate(duration: 400);
                        modle.togelocationloading(false);

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          locationController.text =
                              trans(context, 'tab_set_ur_location');
                        });
                      }
                    } catch (e) {
                      Vibration.vibrate(duration: 400);
                      modle.togelocationloading(false);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        locationController.text =
                            trans(context, 'tab_set_ur_location');
                      });
                    }
                  },
                  suffixicon: IconButton(
                    icon: const Icon(Icons.add_location, color: Colors.orange),
                    onPressed: () {
                      Navigator.pushNamed(context, '/AutoLocate',
                          arguments: <String, dynamic>{
                            "lat": 51.0,
                            "long": 9.6,
                            "choice": 0
                          });
                    },
                  ),
                  obscureText: false,
                  focusNode: focus4,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_set_ur_location');
                    }
                    return modle.regValidationMap['location'];
                  }),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: modle.visibilityObs
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
    return BaseWidget<RegistrationModel>(
        model: getIt<RegistrationModel>(),
        builder: (BuildContext context, RegistrationModel modle,
                Widget child) =>
            Scaffold(
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
                              textAlign: TextAlign.center,
                              style: styles.mystyle2),
                          const SizedBox(height: 8),
                          Text(trans(context, 'please_check'),
                              textAlign: TextAlign.center,
                              style: styles.pleazeCheck),
                          customcard(context, modle),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) =>
                                            colors.orange),
                                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                        (Set<MaterialState> states) => RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: colors.orange))),
                                    textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                                        (Set<MaterialState> states) => TextStyle(color: colors.white))),
                                onPressed: modle.busy
                                    ? null
                                    : () async {
                                        if (_formKey.currentState.validate()) {
                                          if (await modle.register(
                                              context,
                                              usernameController.text,
                                              passwordController.text,
                                              birthDateController.text,
                                              emailController.text,
                                              mobileNoController.text,
                                              locationController.text)) {
                                          } else {
                                            _formKey.currentState.validate();
                                          }
                                          modle.regValidationMap.updateAll(
                                              (String key, String value) {
                                            return null;
                                          });
                                        }
                                      },
                                child: modle.changechildforRegister(trans(context, 'regisration'))),
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
                                    style: styles.mystyle),
                              ),
                              ButtonToUse(trans(context, 'tech_support'),
                                  fontWait: FontWeight.bold,
                                  fontColors: Colors.green),
                            ],
                          ),
                        ],
                      )),
                )));
  }
}
