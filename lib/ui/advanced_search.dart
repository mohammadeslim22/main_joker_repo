import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/providers/counter.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vibration/vibration.dart';
import '../models/search_model.dart';
import '../localization/trans.dart';
import '../constants/styles.dart';
import 'widgets/text_form_input.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/util/functions.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key key}) : super(key: key);
  @override
  AdvanceSearchscreen createState() => AdvanceSearchscreen();
}

class AdvanceSearchscreen extends State<AdvancedSearch>
    with TickerProviderStateMixin {
  Set<int> selectedOptions = <int>{};
  PersistentBottomSheetController<dynamic> _errorController;
  static DateTime today = DateTime.now();
  // final ValueNotifier<DateTime> _dateTimeNotifier =
  //     ValueNotifier<DateTime>(DateTime.now());
  // Widget _buildContractBeginDate(
  //     BuildContext context, ValueNotifier<DateTime> _dateTimeNotifier) {
  //   return RaisedButton(
  //     child: const Text('Starting Date'),
  //     onPressed: () => showDatePicker(
  //       context: context,
  //       firstDate: DateTime(1900),
  //       initialDate: _dateTimeNotifier.value,
  //       lastDate: DateTime(2022),
  //     ).then((DateTime dateTime) => _dateTimeNotifier.value = dateTime),
  //   );
  // }

  // Widget _buildContractEndDate(
  //     BuildContext context, ValueNotifier<DateTime> _dateTimeNotifier) {
  //   return RaisedButton(
  //       child: const Text('Ending Date'),
  //       onPressed: () => showDatePicker(
  //           context: context,
  //           firstDate: _dateTimeNotifier.value,
  //           initialDate: _dateTimeNotifier.value ?? DateTime.now(),
  //           lastDate: DateTime(2022)));
  // }

  String selectedDate = '';
  String dateCount = '';
  String range = '';
  String rangeCount = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate as DateTime) +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format((args.value.endDate as DateTime) ??
                        args.value.startDate as DateTime)
                    .toString();
      } else if (args.value is DateTime) {
        selectedDate = args.value as String;
      } else if (args.value is List<DateTime>) {
        dateCount = args.value.length.toString();
      } else {
        rangeCount = args.value.length.toString();
      }
    });
  }

  Widget temp3;
  Widget temp;
  Widget temp2;
  Widget tempx3;
  Widget tempx;
  Widget tempx2;
  @override
  void initState() {
    super.initState();
    temp = SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(const Duration(days: 3))));
    temp2 = SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(const Duration(days: 3))));
    temp3 = Container(
      child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: PickerDateRange(
              DateTime.now().subtract(const Duration(days: 4)),
              DateTime.now().add(const Duration(days: 3)))),
    );
    tempx = DatePickerWidget(onMonthChangeStartWithFirstDate: {
      DateTime.now(),
      DateTime.now(),
      DateTime.now(),
    });
    tempx2 = DatePickerWidget(onMonthChangeStartWithFirstDate: {
      DateTime.now(),
      DateTime.now(),
      DateTime.now(),
    });
    tempx3 = Container(
      child: DatePickerWidget(onMonthChangeStartWithFirstDate: {
        DateTime.now(),
        DateTime.now(),
        DateTime.now(),
      }),
    );
  }

  String selectedValue;
  final TextEditingController merchantName = TextEditingController();
  final TextEditingController saleName = TextEditingController();
  final FocusNode globalFocus = FocusNode(); 
  final List<SearchModel> options = SearchModel.searchData;
  double _ratingStar = 0;
  bool showingStartingDateCalendar = true;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final MyCounter bolc = Provider.of<MyCounter>(context);
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans(context, "advanced_search"),
            style: styles.mystyle,
          )),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: <Widget>[
          Text(trans(context, "search_through"), style: styles.mystyle),
          const SizedBox(height: 10),
          Column(children: <Widget>[
            TextFormInput(
              text: trans(context, 'shop_name_or_part_of_it'),
              cController: merchantName,
              readOnly: false,
              obscureText: false,
            ),
            TextFormInput(
              text: trans(context, 'offername_or_doscreption'),
              cController: saleName,
              readOnly: false,
              obscureText: false,
            )
          ]),
          const SizedBox(height: 20),
          Text(
            trans(
              context,
              "specializations",
            ),
            style: styles.mystyle,
          ),
          const SizedBox(height: 10),
          GridView.count(
              //  scrollDirection: Axis.vertical,
              //  physics: const ScrollPhysics(),
              shrinkWrap: true,
              primary: true,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 4,
              childAspectRatio: 2,
              addRepaintBoundaries: true,
              children: options.map((SearchModel item) {
                return FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38.0),
                      side: BorderSide(
                        color: selectedOptions.contains(item.id)
                            ? colors.orange
                            : colors.ggrey,
                      ),
                    ),
                    color: colors.white,
                    textColor: selectedOptions.contains(item.id)
                        ? colors.orange
                        : colors.black,
                    onPressed: () {
                      setState(() {
                        if (!selectedOptions.add(item.id)) {
                          selectedOptions.remove(item.id);
                        }
                      });
                    },
                    onLongPress: () {
                      Fluttertoast.showToast(
                          msg: item.search,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[300],
                          textColor: colors.orange,
                          fontSize: 16.0);
                    },
                    child: Text(item.search, style: styles.mysmallforgridview));
              }).toList()),
          const SizedBox(height: 15),
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
                  FocusScope.of(context).requestFocus(globalFocus);
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
                  config.locationController.text = "Tap to set my location";
                });
              }
            },
            suffixicon: IconButton(
              icon: Icon(Icons.add_location),
              onPressed: () {
                Navigator.pushNamed(context, '/AutoLocate',
                    arguments: <String, double>{"lat": 51.0, "long": 9.6});
              },
            ),
            obscureText: false,
          ),
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
        
          Text(trans(context, "offer_history"), style: styles.mystyle),
          const SizedBox(height: 6),
          Text(trans(context, "accourding_offer_start_end_date"),
              style: styles.mysmalllight),
          const SizedBox(height: 10),
          RaisedButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
                side: BorderSide(color: Colors.grey[300])),
            color: colors.white,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.date_range),
                Text(
                  trans(context, "offer_history"),
                  style: styles.mysmalllight,
                ),
                Text("${today.toLocal()}".split(' ')[0]),
                Icon(
                  Icons.arrow_forward,
                  color: colors.orange,
                ),
                Text("${today.toLocal().toString()}".split(' ')[0]),
              ],
            ),
            onPressed: () {
              _errorController = _scaffoldkey.currentState
                  .showBottomSheet<dynamic>((BuildContext context) => Container(
                      height: 400,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  color: showingStartingDateCalendar
                                      ? colors.grey
                                      : colors.trans,
                                  child: FlatButton(
                                    onPressed: () {
                                      _errorController.setState(() {
                                        showingStartingDateCalendar = true;
                                        temp = temp3;
                                      });
                                    },
                                    child: Text(
                                        trans(context, "offer_starting_date")),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: !showingStartingDateCalendar
                                      ? colors.grey
                                      : colors.trans,
                                  child: FlatButton(
                                    onPressed: () {
                                      _errorController.setState(() {
                                        showingStartingDateCalendar = false;
                                        temp = temp2;
                                      });
                                    },
                                    child: Text(
                                        trans(context, "offer_ending_date")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 2),
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: 850),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                // return RotationTransition(
                                //   turns: animation,
                                //   child: child,
                                // );
                                return ScaleTransition(
                                    child: child, scale: animation);
                              },
                              child: temp),
                        ],
                      )));
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                trans(context, "accourding_to_rating"),
                style: styles.mystyle,
              ),
              RatingBar(
                onRatingChanged: (double rating) {
                  setState(() => _ratingStar = rating);
                  // TODO(mislem): use this var to send raiting to API
                  print(_ratingStar);
                },
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                halfFilledIcon: Icons.star_half,
                isHalfAllowed: true,
                filledColor: Colors.amberAccent,
                emptyColor: Colors.grey,
                halfFilledColor: Colors.orange[300],
                size: 30,
              ),
            ],
          ),
          const SizedBox(height: 15),
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
                color: colors.ggrey,
                textColor: colors.white,
                child: Text(trans(context, "cancel"),
                    style: styles.notificationNO),
              ),
              RaisedButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.red)),
                onPressed: () {},
                color: Colors.red,
                textColor: colors.white,
                child: Text(trans(context, "search"),
                    style: styles.notificationNO),
              ),
            ],
          )
        ],
      ),
    );
  }
}
