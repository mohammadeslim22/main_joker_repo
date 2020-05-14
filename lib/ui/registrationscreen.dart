import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/ui/widgets/textforminput.dart';
import 'package:location/location.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:joker/constants/colors.dart';
import 'widgets/buttonTouse.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/src/response.dart';

class Registration extends StatefulWidget {
  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  Future<List<String>> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    final List<String> locaion = <String>[];
    final Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        return locaion;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return locaion;
      }
    }

    locationData = await location.getLocation();
    locaion.add(locationData.latitude.toString());
    locaion.add(locationData.longitude.toString());
    return locaion;
  }

  List<String> location2;
  Location location = Location();
  SpinKitRing spinkit = const SpinKitRing(
    color: Colors.orange,
    size: 30.0,
    lineWidth: 3,
  );
  SnackBar snackBar = SnackBar(
    content: const Text("Location Service was not aloowed  !"),
    action: SnackBarAction(
      label: 'Ok !',
      onPressed: () {},
    ),
  );
  Future<bool> get updateLocation async {
    bool res;
    setState(() {
      config.locationController.text = "getting your location...";
    });
    final List<String> loglat = await getLocation();
    if (loglat.isEmpty) {
      res = false;
    } else {
      setState(() {
        location2 = loglat;
        config.lat = double.parse(location2.elementAt(0));
        config.long = double.parse(location2.elementAt(1));
        res = true;
      });
    }

    return res;
  }

  Future<void> getLocationName() async {
    try {
      config.coordinates = Coordinates(config.lat, config.long);
      config.addresses =
          await Geocoder.local.findAddressesFromCoordinates(config.coordinates);
      config.first = config.addresses.first;
      setState(() {
        config.first = config.addresses.first;
        config.locationController.text = (config.first == null)
            ? "loading"
            : config.first.addressLine ?? "loading";
      });
    } catch (e) {
      config.locationController.text =
          "Unkown latitude: ${config.lat.round().toString()} , longitud: ${config.long.round().toString()}";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool _obscureText = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  static DateTime today = DateTime.now();

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
                  validator: () {
                    return "please enter your name ";
                  }),
              TextFormInput(
                  text: trans(context, 'email'),
                  cController: emailController,
                  prefixIcon: Icons.mail_outline,
                  kt: TextInputType.emailAddress,
                  obscureText: false,
                  readOnly: false,
                  focusNode: focus,
                  onFieldSubmitted: () {
                    focus1.requestFocus();
                  },
                  validator: () {
                    return "please enter your email ";
                  }),
              TextFormInput(
                  text: trans(context, 'mobile_no'),
                  cController: mobileNoController,
                  prefixIcon: Icons.phone,
                  kt: TextInputType.phone,
                  obscureText: false,
                  readOnly: false,
                  suffixwidget: CountryCodePicker(
                    onChanged: _onCountryChange,
                    initialSelection: 'SA',
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
                  validator: () {
                    return "please enter your mobile Number  ";
                  }),
              TextFormInput(
                  text: trans(context, 'password'),
                  cController: passwordController,
                  prefixIcon: Icons.lock_outline,
                  kt: TextInputType.visiblePassword,
                  readOnly: false,
                  suffixwidget: IconButton(
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
                  validator: () {
                    return "please enter your password ";
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
                  suffixwidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("${today.toLocal()}".split(' ')[0]),
                      const SizedBox(
                        height: 20.0,
                      ),
                      IconButton(
                        color: Colors.orange,
                        icon: Icon(
                          Icons.calendar_today,
                        ),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                  focusNode: focus3,
                  validator: () {
                    return "please enter your Birth Date ";
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
                  suffixwidget: IconButton(
                    icon: Icon(Icons.add_location),
                    onPressed: () {
                      Navigator.pushNamed(context, '/AutoLocate',
                          arguments: <String, double>{
                            "lat": 51.0,
                            "long": 9.6
                          });
                      Provider.of<MyCounter>(context)
                          .togelocationloading(false);
                    },
                  ),
                  obscureText: false,
                  focusNode: focus4,
                  validator: () {
                    return "please specify you Location ";
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
      body: ListView(
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
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.orange)),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    bolc.togelf(true);
                    await dio.post<dynamic>("register", data: <String, dynamic>{
                      "name": usernameController.text,
                      "password": passwordController.text,
                      "password_confirmation": passwordController.text,
                      "email": emailController.text,
                      "phone": mobileNoController.text,
                      "country_id": 1,
                      "city_id": 1,
                      "address": "address"
                    }).then((Response<dynamic> value) {
                      bolc.togelf(false);
                      
                    });
                    
                  }
                  Navigator.pushNamed(context, '/login');
                },
                color: Colors.deepOrangeAccent,
                textColor: colors.white,
                child: bolc.returnchild(trans(context, 'Regisration'))),
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
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
