import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import '../widgets/buttonTouse.dart';
import '../widgets/text_form_input.dart';
import 'package:location/location.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/functions.dart';
import 'package:dio/dio.dart';

class Registration extends StatefulWidget {
  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  List<String> location2;
  Location location = Location();

  static List<String> validators = <String>[null, null, null, null, null, null];
  static List<String> keys = <String>[
    'name',
    'email',
    'phone',
    'password',
    'birthdate',
    'location'
  ];
  Map<String, String> validationMap =
      Map<String, String>.fromIterables(keys, validators);
  bool _isButtonEnabled;
  @override
  void initState() {
    super.initState();
    _isButtonEnabled = true;
  }

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

  Widget customcard(BuildContext context, MyCounter bolc) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final FocusNode focus = FocusNode();
    final FocusNode focus1 = FocusNode();
    final FocusNode focus2 = FocusNode();
    final FocusNode focus3 = FocusNode();
    final FocusNode focus4 = FocusNode();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: Form(
            key: _formKey,
            onWillPop: () {
              return _onWillPop();
            },
            child: Column(children: <Widget>[
              TextFormInput(
                  text: trans(context, 'name'),
                  cController: usernameController,
                  prefixIcon: Icons.person_outline,
                  kt: TextInputType.visiblePassword,
                  obscureText: false,
                  readOnly: false,
                  onFieldSubmitted: () {
                    focus.requestFocus();
                  },
                  onTab: () {},
                  validator: (String value) {
                    if (value.length < 3) {
                      return "username must be more than 3 letters";
                    }
                    return validationMap['name'];
                  }),
              TextFormInput(
                  text: trans(context, 'email'),
                  cController: emailController,
                  prefixIcon: Icons.mail_outline,
                  kt: TextInputType.emailAddress,
                  obscureText: false,
                  readOnly: false,
                  focusNode: focus,
                  onTab: () {},
                  onFieldSubmitted: () {
                    focus1.requestFocus();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "please enter a valid email ";
                    }
                    return validationMap['email'];
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
                    initialSelection: 'TR',
                    favorite: const <String>['+966', 'SA'],
                    showFlagDialog: true,
                    showFlag: false,
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
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
                      return "please enter your mobile Number  ";
                    }
                    return validationMap['phone'];
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
                      return "password must be more than 6 letters";
                    }
                    return validationMap['password'];
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
                  suffixicon: IconButton(
                    color: Colors.orange,
                    icon: Icon(
                      Icons.calendar_today,
                    ),
                    onPressed: () {
                    //  _selectDate(context);
                    },
                  ),
                  focusNode: focus3,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "please enter your Birth Date ";
                    }
                    return validationMap['birthdate'];
                  }),
              TextFormInput(
                  text: trans(context, 'get_location'),
                  cController: config.locationController,
                  prefixIcon: Icons.my_location,
                  kt: TextInputType.visiblePassword,
                  readOnly: true,
                  onTab: () async {
                    try {
                      bolc.togelocationloading(true);
                      if (await updateLocation) {
                        await getLocationName();
                        bolc.togelocationloading(false);
                      } else {
                        Vibration.vibrate(duration: 400);
                        bolc.togelocationloading(false);

                        Scaffold.of(context).showSnackBar(snackBar);
                        //  Scaffold.of(context).hideCurrentSnackBar();
                        setState(() {
                          config.locationController.text =
                              "Tap to set my location";
                        });
                      }
                    } catch (e) {
                      Vibration.vibrate(duration: 400);
                      bolc.togelocationloading(false);
                      Scaffold.of(context).showSnackBar(snackBar);
                      setState(() {
                        config.locationController.text =
                            "Tap to set my location";
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
                      return "please specify you Location :)";
                    }
                    return validationMap['location'];
                  }),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: bolc.visibilityObs
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
    final MyCounter bolc = Provider.of<MyCounter>(context);
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
                      Text(
                        trans(context, 'please_check'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.values.first,
                          color: const Color(0xFF303030),
                          fontSize: 20,
                        ),
                      ),
                      customcard(context, bolc),
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
                                  bolc.togelf(true);
                                  setState(() {
                                    _isButtonEnabled = false;
                                  });
                                  await dio.post<dynamic>("register",
                                      data: <String, dynamic>{
                                        "name": usernameController.text,
                                        "password": passwordController.text,
                                        "password_confirmation":
                                            passwordController.text,
                                        "birth_date": birthDateController.text,
                                        "email": emailController.text,
                                        "phone": countryCodeTemp +
                                            mobileNoController.text,
                                        "country_id": 1,
                                        "city_id": 1,
                                        "address":
                                            config.locationController.text,
                                        "longitude": config.long,
                                        "latitude": config.lat
                                      }).then((Response<dynamic> value) async {
                                    setState(() {
                                      _isButtonEnabled = true;
                                    });

                                    if (value.statusCode == 422) {
                                      value.data['errors']
                                          .forEach((String k, dynamic vv) {
                                        setState(() {
                                          validationMap[k] = vv[0].toString();
                                        });
                                        print(validationMap);
                                      });
                                      _formKey.currentState.validate();
                                      validationMap.updateAll(
                                          (String key, String value) {
                                        return null;
                                      });
                                    }
                                    if (value.statusCode == 201) {
                                      print(value.data['data']['id']);

                                      Navigator.pushNamed(context, '/pin',
                                          arguments: <String, String>{
                                            'mobileNo': countryCodeTemp +
                                              mobileNoController.text
                                          });
                                      config.locationController.clear();
                                     await data.setData("id",
                                          value.data['data']['id'].toString());
                                      data.setData(
                                          "email", emailController.text);
                                      data.setData(
                                          "username", usernameController.text);
                                      data.setData(
                                          "password", passwordController.text);
                                      data.setData(
                                          "phone",
                                          countryCodeTemp +
                                              mobileNoController.text);
                                      data.setData(
                                          "lat", config.lat.toString());
                                      data.setData(
                                          "long", config.long.toString());
                                      data.setData(
                                          "address",
                                          config.locationController.text
                                              .toString());
                                    }
                                    bolc.togelf(false);
                                  });
                                }
                              }
                            },
                            color: Colors.deepOrangeAccent,
                            textColor: colors.white,
                            child: bolc
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
                            fw: FontWeight.bold,
                            fc: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                )));
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      countryCodeTemp = countryCode.dialCode;
    });

    FocusScope.of(context).requestFocus(FocusNode());
  }
}
