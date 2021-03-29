import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../models/membership.dart';

class MemberShipDetails extends StatefulWidget {
  const MemberShipDetails({Key key, this.mermbershipData}) : super(key: key);
  final MembershipData mermbershipData;
  @override
  _MemberShipDetailsState createState() => _MemberShipDetailsState();
}

class _MemberShipDetailsState extends State<MemberShipDetails> {
  final double hight = 30;

  bool isactivated = true;
  MembershipData mermbershipData;
  PersistentBottomSheetController<dynamic> _errorController;
  Set<int> selectedOptions = <int>{};

  GlobalKey<ScaffoldState> _scaffoldkey;

  @override
  void initState() {
    super.initState();
    mermbershipData = widget.mermbershipData;
    _scaffoldkey = GlobalKey<ScaffoldState>();
  }

  final List<String> options = const <String>[
    "yearly",
    "monthly",
    "sesonly",
    "weekly"
  ];

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
                Text(mermbershipData.membership.meesage,
                    textWidthBasis: TextWidthBasis.parent,
                    style: styles.memberSipMessageText),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            trans(context, "membership_details"),
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
                            mermbershipData.membership.merchant,
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
                            mermbershipData.membership.gender,
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
                            mermbershipData.membership.ageStage,
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
                            mermbershipData.createdAt,
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
                            mermbershipData.startAt,
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
                            mermbershipData.status,
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
                            "390.00",
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.grey)),
                    textStyle: const TextStyle(color: Colors.white),
                    onPrimary: Colors.grey,
                  ),
                  onPressed: () {},
                  child: Text(trans(context, "cancel"),
                      style: styles.notificationNO)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.red))),
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
                            Text(trans(context, 'membership_to'),
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
                                    Text(mermbershipData.membership.merchant,
                                        style: styles
                                            .memberShipBottomSheetmercahnt)
                                  ]),
                            ),
                            const SizedBox(height: 16),
                            Text(trans(context, 'membership_type'),
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
                                  return TextButton(
                                      style: ElevatedButton.styleFrom(
                                          onPrimary: selectedOptions.contains(
                                                  options.indexOf(item))
                                              ? colors.white
                                              : colors.white.withOpacity(.45),
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
                                          textStyle: TextStyle(
                                              color: selectedOptions.contains(
                                                      options.indexOf(item))
                                                  ? colors.orange
                                                  : colors.white)),
                                      onPressed: () {
                                        _errorController.setState(() {
                                          selectedOptions.clear();
                                          selectedOptions
                                              .add(options.indexOf(item));
                                        });
                                      },
                                      child: Text(trans(context, item),
                                          style: styles.mysmallforgridview));
                                }).toList()),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(trans(context, 'membership_status'),
                                    style: styles.memberShipBottomSheet),
                                ToggleSwitch(
                                    minWidth: 90.0,
                                    cornerRadius: 20,
                                    activeBgColor: Colors.white,
                                    // activeTextColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    // inactiveTextColor: Colors.white,
                                    labels: <String>[
                                      trans(context, 'activated'),
                                      trans(context, 'deactivated')
                                    ],
                                    icons: const <IconData>[
                                      Icons.power_settings_new,
                                      Icons.blur_off
                                    ],
                                    activeBgColors: <Color>[
                                      colors.orange,
                                      colors.orange,
                                    ],
                                    onToggle: (int index) {}),
                              ],
                            ),
                            const SizedBox(height: 42),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 25),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: colors.orange)),
                                    onPrimary: colors.orange,
                                    textStyle: TextStyle(color: colors.white),
                                    // textColor: colors.white,
                                  ),
                                  onPressed: () {},
                                  child: Text(trans(context, "search"),
                                      style: styles.notificationNO),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 25),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.grey)),
                                      onPrimary: Colors.red,
                                      textStyle:
                                          const TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    _errorController.close();
                                  },
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
                child: Text(trans(context, "update"),
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
