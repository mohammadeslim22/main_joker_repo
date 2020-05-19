import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:joker/models/profile.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'widgets/text_form_input.dart';
import 'package:joker/util/functions.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class MyAccount extends StatefulWidget {
  @override
  MyAccountPage createState() => MyAccountPage();
}

class MyAccountPage extends State<MyAccount> {
  List<String> location2;
  Location location = Location();
  SnackBar snackBar = SnackBar(
    content: const Text("Location Service was not aloowed  !"),
    action: SnackBarAction(
      label: 'Ok !',
      onPressed: () {},
    ),
  );
  SpinKitRing spinkit = const SpinKitRing(
    color: Colors.orange,
    size: 30.0,
    lineWidth: 3,
  );
  bool _obscureText = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  static DateTime today = DateTime.now();
  Profile profile;
  DateTime firstDate = DateTime(today.year - 90, today.month, today.day);
  DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
  final FocusNode focus = FocusNode();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final FocusNode focus3 = FocusNode();
  final FocusNode focus4 = FocusNode();
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

  Future<Profile> getProfileData() async {
    print(await data.getData("authorization"));
    final dynamic response = await dio.get<dynamic>("user");

    profile = Profile.fromJson(response.data);
    return profile;
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

  bool showImageOptions = false;
@override
void initState() {
    super.initState();
    
    getProfileData().then((Profile value) {
      setState(() {
        usernameController.text=value.name;
        emailController.text=value.email;
        mobileNoController.text=value.phone;
        birthDateController.text=value.updatedAt;
        config.locationController.text="${value.address}";
        passwordController.text="***********";
        
      });
      
    });
  }
  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final MyCounter bolc = Provider.of<MyCounter>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(trans(context, "my_account")),
          centerTitle: true,
        ),
        body: Builder(
            builder: (BuildContext context) => GestureDetector(
                onTap: () {
                  SystemChannels.textInput
                      .invokeMethod<String>('TextInput.hide');
                  if (showImageOptions)
                    setState(() {
                      showImageOptions = false;
                    });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipPath(
                      clipper: HeaderColor(),
                      child: Container(
                        color: Colors.orange[300].withOpacity(0.3),
                      ),
                    ),
                    ListView(children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push<dynamic>(context,
                                    MaterialPageRoute<dynamic>(builder: (_) {
                                  return const FullScreenImage(
                                    imageUrl:
                                        'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4',
                                    tag: "generate_a_unique_tag",
                                  );
                                }));
                              },
                              child: Hero(
                                child: CircularProfileAvatar(
                                  'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                                  radius: 80,
                                  backgroundColor: Colors.transparent,
                                  borderWidth: 5,
                                  borderColor: Colors.orange,
                                  cacheImage: true,
                                ),
                                tag: "generate_a_unique_tag",
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100,
                            left: MediaQuery.of(context).size.width / 2 + 52,
                            child: InkWell(
                              highlightColor: colors.trans,
                              splashColor: colors.trans,
                              onTap: () {
                                setState(() {
                                  showImageOptions = !showImageOptions;
                                });
                              },
                              child: SvgPicture.asset(
                                'assets/images/add_profile_pic.svg',
                                width: 36,
                                height: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (showImageOptions)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                  child: Text('Take A Photo',
                                      style: styles.mysmall),
                                  onPressed: () {}),
                              FlatButton(
                                child:
                                    Text('Open Gallery', style: styles.mysmall),
                                onPressed: () {},
                              )
                            ],
                          ),
                        )
                      else
                        Container(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Column(
                          children: <Widget>[
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
                                onTab: () {},
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
                                onTab: () {},
                                suffixicon: CountryCodePicker(
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
                                text: trans(context, 'birth_date'),
                                cController: birthDateController,
                                prefixIcon: Icons.date_range,
                                kt: TextInputType.visiblePassword,
                                obscureText: false,
                                readOnly: true,
                                onTab: () {
                                  _selectDate(context);
                                },
                                suffixicon: Row(
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

                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
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
                                  return "please specify you Location :)";
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
                                validator: () {
                                  return "please enter your password ";
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
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: colors.orange)),
                            onPressed: () async {},
                            color: Colors.deepOrangeAccent,
                            textColor: Colors.white,
                            child: Text(
                              trans(context, 'save_changes'),
                              style: styles.notificationNO,
                            )),
                      ),
                    ]),
                  ],
                ))));
  }

  void _onCountryChange(CountryCode value) {}
}

class HeaderColor extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 400);
    path.lineTo(size.width, size.height - 460);
    path.lineTo(size.width, size.height - 560);
    path.lineTo(0.0, size.height - 500);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({Key key, this.imageUrl, this.tag}) : super(key: key);
  final String imageUrl;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.ggrey,
        leading: IconButton(
          color: colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);

            SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
          },
        ),
      ),
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
              imageUrl: imageUrl,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
