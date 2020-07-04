import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:joker/ui/widgets/text_form_input.dart';
import 'package:joker/util/functions.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dio/dio.dart';

class MyAccount extends StatefulWidget {
  @override
  MyAccountPage createState() => MyAccountPage();
}

class MyAccountPage extends State<MyAccount> with AfterLayoutMixin<MyAccount> {
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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
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
  File myimage;
  Future<Profile> getProfileData() async {
    print(await data.getData("authorization"));
    final dynamic response = await dio.get<dynamic>("user");

    profile = Profile.fromJson(response.data);
    return profile;
  }

  // Future<void> getImage() async {
  //   final File image =
  //       await ImagePicker.getImage(source: ImageSource.gallery) as File;

  //   setState(() {
  //     myimage = image;
  //   });
  // }

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

  String tempPhone;
  bool showImageOptions = false;
  bool _isButtonEnabled;
  @override
  void initState() {
    super.initState();

    _isButtonEnabled = true;
    getProfileData().then((Profile value) {
      setState(() {
        usernameController.text = value.name;
        emailController.text = value.email;
        mobileNoController.text = value.phone;
        tempPhone = value.phone;
        birthDateController.text = value.updatedAt;
        config.locationController.text = "${value.address}";
      });
    });
  }

  void shoeTosted() {
    showToast('new Phone number was Not Verfiyed!',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: const Offset(0.0, 3.0),
        reverseEndOffset: const Offset(0.0, 3.0),
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 4),
        //Animation duration   animDuration * 2 <= duration
        animDuration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn);
    return;
  }

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                              onTap: () {},
                              child: Hero(
                                child: CircularProfileAvatar(
                                  config.profileUrl ?? "",
                                  radius: 80,
                                  backgroundColor: Colors.transparent,
                                  borderWidth: 5,
                                  placeHolder:
                                      (BuildContext context, String url) =>
                                          const CircularProgressIndicator(),
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
                                  onPressed: () async {
                                    getImage(ImageSource.camera, bolc);
                                  }),
                              FlatButton(
                                child:
                                    Text('Open Gallery', style: styles.mysmall),
                                onPressed: () async {
                                  getImage(ImageSource.gallery, bolc);
                                },
                              ),
                              if (myimage == null)
                                Container()
                              else
                                Image.file(myimage),
                            ],
                          ),
                        )
                      else
                        Container(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 34),
                        child: Form(
                          key: _formKey,
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
                                  readOnly: true,
                                  focusNode: focus,
                                  suffixicon: IconButton(
                                    icon:
                                        Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () {},
                                  ),
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
                                  readOnly: true,
                                  onTab: () {
                                    print(mobileNoController.text);
                                    Navigator.pushNamed(
                                      context,
                                      '/pinForProfile',
                                      arguments: <String, String>{
                                        'mobileNo': mobileNoController.text
                                      },
                                    );
                                  },
                                  suffixicon: IconButton(
                                    icon:
                                        Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () {
                                      print(mobileNoController.text);
                                    },
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
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {
                                      //   _selectDate(context);
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

                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          config.locationController.text =
                                              "Tap to set my location";
                                        });
                                      }
                                    } catch (e) {
                                      Vibration.vibrate(duration: 400);
                                      bolc.togelocationloading(false);
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                      setState(() {
                                        config.locationController.text =
                                            "Tap to set my location";
                                      });
                                    }
                                  },
                                  suffixicon: IconButton(
                                    icon: Icon(Icons.add_location,
                                        color: Colors.orange),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/AutoLocate',
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: RaisedButton(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: colors.orange)),
                            onPressed: () async {
                              if (_isButtonEnabled) {
                                if (_formKey.currentState.validate()) {
                                  bolc.togelf(true);
                                  setState(() {
                                    _isButtonEnabled = false;
                                  });

                                  login(bolc);
                                }
                              }
                            },
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

  Future<void> getImage(ImageSource imageSource, MyCounter bolc) async {
    final File image = await ImagePicker.pickImage(source: imageSource);
    if (image != null) {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        "avatar": await MultipartFile.fromFile(image.path)
      });
      dio
          .post<dynamic>(
        "avatar",
        data: formData,
        // queryParameters: <String, dynamic>{"avater": formData},
        onSendProgress: (int sent, int total) {},
      )
          .then((dynamic result) {
        print(result.data);
        if (result.statusCode == 200) {
          bolc.changeImageUrl(result.data['image'].toString());
          data.setData('profile_pic', result.data['image'].toString());

          setState(() {
            config.profileUrl = result.data['image'].toString();
          });
        }
      });
    }
  }

  Future<void> login(MyCounter bolc) async {
    await dio.post<dynamic>("update", data: <String, dynamic>{
      "name": usernameController.text,
      "birth_date": birthDateController.text,
      "email": emailController.text,
      "country_id": 1,
      "city_id": 1,
      "address": config.locationController.text,
      "longitude": config.long,
      "latitude": config.lat
    }).then((Response<dynamic> value) {
      setState(() {
        _isButtonEnabled = true;
      });
      print(value.data);
      if (value.statusCode == 422) {
        value.data['errors'].forEach((String k, dynamic vv) {
          setState(() {
            validationMap[k] = vv[0].toString();
          });
          print(validationMap);
        });
        _formKey.currentState.validate();
        validationMap.updateAll((String key, String value) {
          return null;
        });
        print(validationMap);
      }
      if (value.statusCode == 200) {
        data.setData("email", emailController.text);
        data.setData("username", usernameController.text);
        // data.setData("phone", mobileNoController.text);
        data.setData("lat", config.lat.toString());
        data.setData("long", config.long.toString());
        data.setData("address", config.locationController.text.toString());

        showGeneralDialog<dynamic>(
          barrierLabel: "Label",
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.73),
          transitionDuration: const Duration(milliseconds: 350),
          context: context,
          pageBuilder: (BuildContext context, Animation<double> anim1,
              Animation<double> anim2) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 360,
                margin: const EdgeInsets.only(bottom: 160, left: 36, right: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: SizedBox.expand(
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset('assets/images/checkdone.svg'),
                        const SizedBox(height: 15),
                        Text(trans(context, "information_updated_successfully"),
                            style: styles.underHeadblack),
                        const SizedBox(height: 15),
                        RaisedButton(
                            color: colors.orange,
                            child: Text(trans(context, "ok"),
                                style: styles.underHeadwhite),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          transitionBuilder: (BuildContext context, Animation<double> anim1,
              Animation<double> anim2, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, 1), end: const Offset(0, 0))
                  .animate(anim1),
              child: child,
            );
          },
        );
      }
      bolc.togelf(false);
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (config.prifleNoVerfiyDone) {
    } else {
      if (config.prifleNoVerfiyVisit) {
        shoeTosted();
      }
    }
  }
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
