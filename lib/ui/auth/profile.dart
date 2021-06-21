import 'dart:io';
// import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:joker/models/profile.dart';
import 'package:joker/providers/auth.dart';
import 'package:joker/base_widget.dart';
import 'package:joker/ui/view_models/auth_view_models/profile_model.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/service_locator.dart';
import 'package:vibration/vibration.dart';
import 'package:joker/ui/widgets/text_form_input.dart';
import 'package:joker/util/functions.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dio/dio.dart';
import 'package:loading_indicator/loading_indicator.dart';

// import '../base_widget.dart';

class MyAccount extends StatefulWidget {
  @override
  MyAccountPage createState() => MyAccountPage();
}

class MyAccountPage extends State<MyAccount>
    with /* AfterLayoutMixin<MyAccount>,*/ TickerProviderStateMixin {
  List<String> location2;
  SnackBar snackBar = SnackBar(
    content: const Text("Location Service was not aloowed  !"),
    action: SnackBarAction(
      label: 'Ok !',
      onPressed: () {},
    ),
  );
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

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
  String imageUrl;
  bool imageUplaoding = true;
  AnimationController animationController1,
      animationController2,
      animationController3;

  Animation<double> animation1, animation2, animation3;

  void shoeTosted() {
    showToast('new Phone number was Not Verfiyed!',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: const Offset(0.0, 3.0),
        reverseEndOffset: const Offset(0.0, 3.0),
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn);
    return;
  }

  Widget t;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ProfileModle>(
        onModelReady: (ProfileModle model) async {
          
          final Map<String, String> user = await model.getUserData();
          setState(() {
            usernameController.text =
                user["name"] != "null" ? user["name"] : "";
            emailController.text = user["email"] != "null" ? user["email"] : "";
            mobileNoController.text =
                user["phone"] != "null" ? user["phone"] : "";
            imageUrl = user["image"] != "null" ? user["image"] : config.imageUrl;
            birthDateController.text =
                user["birthdate"] != "null" ? user["birthdate"] : "";
            locationController.text =
                user["address"] != "null" ? user["address"] : "";
          });
        },
        model: getIt<ProfileModle>(),
        builder: (BuildContext context, ProfileModle modle, Widget child) =>
            Scaffold(
                appBar: AppBar(
                    title: Text(trans(context, "my_account"),
                        style: styles.appBars),
                    centerTitle: true),
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
                              const SizedBox(height: 6),
                              Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Visibility(
                                        visible: imageUplaoding,
                                        child: Hero(
                                          child: CircularProfileAvatar(
                                              imageUrl ??
                                                  getIt<Auth>().userPicture ??
                                                  config.profileUrl,
                                              animateFromOldImageOnUrlChange:
                                                  true,
                                              radius: 80,
                                              backgroundColor:
                                                  Colors.transparent,
                                              borderWidth: 5,
                                              progressIndicatorBuilder:
                                                  (BuildContext context,
                                                          String s,
                                                          DownloadProgress
                                                              url) =>
                                                      const CircularProgressIndicator(),
                                              borderColor: colors.orange,
                                              cacheImage: true),
                                          tag: "generate_a_unique_tag",
                                        ),
                                        replacement: Stack(
                                          children: <Widget>[
                                            SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                        backgroundColor:
                                                            colors.trans),
                                                height: 160,
                                                width: 160),
                                            Container(
                                              height: 160,
                                              width: 160,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: LoadingIndicator(
                                                    color: Colors.orange,
                                                    indicatorType:
                                                        Indicator.values[19],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 100,
                                    left:
                                        MediaQuery.of(context).size.width / 2 +
                                            52,
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
                                          height: 36),
                                    ),
                                  ),
                                ],
                              ),
                              if (showImageOptions)
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    children: <Widget>[
                                      TextButton(
                                          child: Text(
                                              trans(context, 'open_gallery'),
                                              style: styles.mysmall),
                                          onPressed: () async {
                                            getImage(
                                                ImageSource.gallery, modle);
                                          }),
                                      TextButton(
                                        child: Text(
                                            trans(context, "take_photo"),
                                            style: styles.mysmall),
                                        onPressed: () async {
                                          getImage(ImageSource.camera, modle);
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 34),
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
                                            return modle
                                                .profileValidationMap['name'];
                                          }),
                                      TextFormInput(
                                          text: trans(context, 'email'),
                                          cController: emailController,
                                          prefixIcon: Icons.mail_outline,
                                          kt: TextInputType.emailAddress,
                                          obscureText: false,
                                          readOnly: false,
                                          focusNode: focus,
                                          suffixicon: IconButton(
                                            icon: Icon(Icons.edit,
                                                color: colors.orange),
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
                                            return modle
                                                .profileValidationMap['email'];
                                          }),
                                      TextFormInput(
                                          text: trans(context, 'mobile_no'),
                                          cController: mobileNoController,
                                          prefixIcon: Icons.phone,
                                          kt: TextInputType.phone,
                                          obscureText: false,
                                          readOnly: true,
                                          onTab: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/pinForProfile',
                                              arguments: <String, String>{
                                                'mobileNo':
                                                    mobileNoController.text
                                              },
                                            );
                                          },
                                          suffixicon: IconButton(
                                            icon: Icon(Icons.edit,
                                                color: colors.orange),
                                            onPressed: () {},
                                          ),
                                          focusNode: focus1,
                                          onFieldSubmitted: () {
                                            focus2.requestFocus();
                                          },
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "please enter your mobile Number  ";
                                            }
                                            return modle
                                                .profileValidationMap['phone'];
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
                                            color: colors.orange,
                                            icon: const Icon(
                                                Icons.calendar_today),
                                            onPressed: () {},
                                          ),
                                          focusNode: focus3,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "please enter your Birth Date ";
                                            }
                                            return modle.profileValidationMap[
                                                'birthdate'];
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
                                              final Map<String, dynamic>
                                                  location =
                                                  await updateLocation;
                                              if (location["res"] as bool) {
                                                setState(() {
                                                  locationController.text =
                                                      location["address"]
                                                          .toString();
                                                });
                                                modle
                                                    .togelocationloading(false);
                                              } else {
                                                Vibration.vibrate(
                                                    duration: 400);
                                                modle
                                                    .togelocationloading(false);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                setState(() {
                                                  locationController.text =
                                                      trans(context,
                                                          "error_happened");
                                                });
                                              }
                                            } catch (e) {
                                              Vibration.vibrate(duration: 400);
                                              modle.togelocationloading(false);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              setState(() {
                                                locationController.text =
                                                    "Tap to set my location";
                                              });
                                            }
                                          },
                                          suffixicon: IconButton(
                                            icon: Icon(Icons.add_location,
                                                color: colors.orange),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/AutoLocate',
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
                                              return "please specify you Location :)";
                                            }
                                            return modle.profileValidationMap[
                                                'location'];
                                          }),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: modle.visibilityObs
                                            ? Row(
                                                children: <Widget>[
                                                  Expanded(child: spinkit),
                                                ],
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 70),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: colors.orange)),
                                        onPrimary: colors.orange,
                                        textStyle:
                                            TextStyle(color: colors.white)),
                                    onPressed: modle.busy
                                        ? null
                                        : () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              await modle
                                                  .updateProfile(
                                                      usernameController.text,
                                                      birthDateController.text,
                                                      emailController.text,
                                                      locationController.text)
                                                  .then((bool value) {
                                                if (value) {
                                                  ifUpdateTur(context,
                                                      "information_updated_successfully");
                                                } else {
                                                  _formKey.currentState
                                                      .validate();
                                                }
                                                modle.profileValidationMap
                                                    .updateAll((String key,
                                                        String value) {
                                                  return null;
                                                });
                                              });
                                            }
                                          },
                                    child: modle.returnchildforProfile(
                                      trans(context, 'save_changes'),
                                      //  style: styles.notificationNO,
                                    )),
                              ),
                            ]),
                          ],
                        )))));
  }

  Future<void> getImage(ImageSource imageSource, ProfileModle modle) async {
    final PickedFile image = await ImagePicker().getImage(source: imageSource);
    if (image != null) {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        "avatar": await MultipartFile.fromFile(image.path)
      });
      setState(() {
        imageUrl = "";
        imageUplaoding = false;
      });
      modle.changeProfilePic(formData).then((dynamic result) {
        if (result.statusCode == 200) {
          getIt<Auth>().setUserPicture(result.data['image'].toString());
          data.setData('profile_pic', result.data['image'].toString());
          setState(() {
            showImageOptions = !showImageOptions;
            config.profileUrl = result.data['image'].toString();
            imageUrl = result.data['image'].toString();
            imageUplaoding = true;
          });
        } else {
          Fluttertoast.showToast(msg: trans(context, "error_happened"));
        }
      });
    }
  }

  // @override
  // void afterFirstLayout(BuildContext context) {
  //   if (config.prifleNoVerfiyDone) {
  //   } else {
  //     if (config.prifleNoVerfiyVisit) {
  //       shoeTosted();
  //     }
  //   }
  //}
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
