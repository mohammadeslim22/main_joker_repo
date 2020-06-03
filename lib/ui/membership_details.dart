import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MemberShipDetails extends StatefulWidget {
  @override
  _MemberShipDetailsState createState() => _MemberShipDetailsState();
}

class _MemberShipDetailsState extends State<MemberShipDetails> {
  final double hight = 30;

  bool isactivated = true;

  final List<String> options = const <String>[
    "سنوي",
    "شهري",
    "موسمي",
    "اسبوعي"
  ];

  PersistentBottomSheetController<dynamic> _errorController;
  Set<int> selectedOptions = <int>{};

  GlobalKey<ScaffoldState> _scaffoldkey;

  @override
  void initState() {
    super.initState();
    _scaffoldkey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(trans(context, "membership_details")),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  trans(context, "membership_message"),
                  style: styles.memberShipMessage,
                ),
                const SizedBox(height: 6),
                Text(
                    "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها. ولذلك يتم استخدام طريقة لوريم إيبسوم لأنها تعطي توزيعاَ طبيعياَ -إلى حد ما- للأحرف عوضاً ",
                    textWidthBasis: TextWidthBasis.parent,
                    style: styles.memberSipMessageText),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            trans(context, "membership_message"),
            style: styles.underHead,
          ),
          const SizedBox(height: 12),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: hight,
                      color: colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trans(context, 'membership_to')}",
                            style: styles.smallButton,
                          ),
                          Text(
                            "${trans(context, 'account')}",
                            style: styles.smallButton,
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: hight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trans(context, 'gender')}",
                            style: styles.smallButton,
                          ),
                          Text(
                            "${trans(context, 'account')}",
                            style: styles.smallButton,
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: hight,
                      color: colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trans(context, 'age')}",
                            style: styles.smallButton,
                          ),
                          Text(
                            "${trans(context, 'account')}",
                            style: styles.smallButton,
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: hight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trans(context, 'consruction_date')}",
                            style: styles.smallButton,
                          ),
                          Text(
                            "${trans(context, 'account')}",
                            style: styles.smallButton,
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: hight,
                      color: colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trans(context, 'affiliation_date')}",
                            style: styles.smallButton,
                          ),
                          Text(
                            "${trans(context, 'account')}",
                            style: styles.smallButton,
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: hight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trans(context, 'membership_status')}",
                            style: styles.smallButton,
                          ),
                          Text(
                            "${trans(context, 'account')}",
                            style: styles.smallButton,
                          ),
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: hight,
                      color: colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trans(context, 'associate_members_count')}",
                            style: styles.smallButton,
                          ),
                          Text(
                            "${trans(context, 'account')}",
                            style: styles.smallButton,
                          ),
                        ],
                      )),
                ],
              )),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.grey)),
                onPressed: () {},
                color: Colors.grey,
                textColor: Colors.white,
                child: Text(trans(context, "cancel"),
                    style: styles.notificationNO),
              ),
              RaisedButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.red)),
                onPressed: () async {
                  _errorController =
                      _scaffoldkey.currentState.showBottomSheet<dynamic>(
                    (BuildContext context) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                      ),
                      height: 412,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset("assets/images/vip.svg"),
                                Text(
                                  trans(context, "membership_details_edit"),
                                  style: styles.memberShipBottomSheet,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text("عضوية لدى",
                                style: styles.memberShipBottomSheet),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.45),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text("متجر كابيتال مول",
                                        style: styles
                                            .memberShipBottomSheetmercahnt)
                                  ]),
                            ),
                            const SizedBox(height: 16),
                            Text("نوع العضوية",
                                style: styles.memberShipBottomSheet),
                            const SizedBox(height: 12),
                            GridView.count(
                                shrinkWrap: true,
                                primary: true,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                crossAxisCount: 4,
                                childAspectRatio: 2,
                                addRepaintBoundaries: true,
                                children: options.map((String item) {
                                  return FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(38.0),
                                        side: BorderSide(
                                          color: selectedOptions.contains(
                                                  options.indexOf(item))
                                              ? colors.orange
                                              : colors.grey,
                                        ),
                                      ),
                                      color: selectedOptions
                                              .contains(options.indexOf(item))
                                          ? colors.white
                                          : colors.white.withOpacity(.45),
                                      textColor: selectedOptions
                                              .contains(options.indexOf(item))
                                          ? colors.orange
                                          : colors.white,
                                      onPressed: () {
                                        _errorController.setState(() {
                                          selectedOptions.clear();
                                          selectedOptions
                                              .add(options.indexOf(item));
                                        });
                                      },
                                      child: Text(item,
                                          style: styles.mysmallforgridview));
                                }).toList()),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("الحالة",
                                    style: styles.memberShipBottomSheet),
                                ToggleSwitch(
                                    minWidth: 90.0,
                                    cornerRadius: 20,
                                    activeBgColor: Colors.white,
                                    activeTextColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveTextColor: Colors.white,
                                    labels: const <String>['مفعل', 'غير مفعل'],
                                    icons: <IconData>[
                                      Icons.power_settings_new,
                                      Icons.blur_off
                                    ],
                                    activeColors: const <Color>[
                                      Colors.orange,
                                      Colors.orange
                                    ],
                                    onToggle: (int index) {
                                      print('switched to: $index');
                                    }),
                              ],
                            ),
                            const SizedBox(height: 42),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 25),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.orange)),
                                  onPressed: () {},
                                  color: Colors.orange,
                                  textColor: Colors.white,
                                  child: Text(trans(context, "search"),
                                      style: styles.notificationNO),
                                ),
                                RaisedButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 25),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          const BorderSide(color: Colors.grey)),
                                  onPressed: () {
                                    _errorController.close();
                                  },
                                  color: Colors.grey,
                                  textColor: Colors.white,
                                  child: Text(trans(context, "cancel"),
                                      style: styles.notificationNO),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24)
                          ]),
                    ),
                  );
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text(trans(context, "search"),
                    style: styles.notificationNO),
              ),
            ],
          ),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}
