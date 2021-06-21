import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../localization/trans.dart';
import '../constants/styles.dart';
import 'widgets/text_form_input.dart';
import 'package:joker/constants/colors.dart';
import 'package:flutter/services.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key key, this.scaffoldkey, this.specializations})
      : super(key: key);

  @override
  _PageState createState() => _PageState();
  final GlobalKey<ScaffoldState> scaffoldkey;
  final List<Specialization> specializations;
}

class _PageState extends State<AdvancedSearch> with TickerProviderStateMixin {
  Set<int> selectedOptions = <int>{};
  PersistentBottomSheetController<dynamic> _errorController;
  static DateTime starttoday = DateTime.now().subtract(const Duration(days: 1500));
  static DateTime endtoday = DateTime.now().add(const Duration(days: 1500));
  String startDate = "${starttoday.toLocal()}".split(' ')[0];
  String endDate = "${endtoday.toLocal()}".split(' ')[0];
  AnimationController _animationController;
  // final CalendarController _calendarController = CalendarController();
  DateTime focusDay = DateTime.now();

  bool showingStartingDateCalendar = true;
  Widget t;
  Widget tt;
  Widget ttt;
  double startingPrive = 0.0;
  double endingPrive = 450.0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    t = TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            const TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
    );
  
    ttt = Container(child: t);
    tt = t;
  }

  void _onDaySelected(DateTime day, List<dynamic> events, List<dynamic> event) {
    if (showingStartingDateCalendar) {
      setState(() {
        starttoday = day;
        startDate = "${starttoday.toLocal()}".split(' ')[0];
      });
    } else {
      setState(() {
        endtoday = day;
        endDate = "${endtoday.toLocal()}".split(' ')[0];
        showingStartingDateCalendar = true;
        _errorController.close();
      });
    }
  }


  String selectedValue;
  final TextEditingController merchantName = TextEditingController();
  final TextEditingController saleName = TextEditingController();
    final TextEditingController locationController = TextEditingController();

  final FocusNode globalFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
        },
        child: Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
                centerTitle: true,
                title: Text(trans(context, "advanced_search"),
                    style: styles.mystyle)),
            body: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                Text(trans(context, "search_through"), style: styles.mystyle),
                const SizedBox(height: 8),
                Column(children: <Widget>[
                  TextFormInput(
                    text: trans(context, 'shop_name_or_part_of_it'),
                    cController: merchantName,
                    readOnly: false,
                    obscureText: false,
                    onTab: () {
                      _errorController.close();
                    },
                  ),
                  TextFormInput(
                    text: trans(context, 'offername_or_doscreption'),
                    cController: saleName,
                    readOnly: false,
                    obscureText: false,
                    onTab: () {
                      _errorController.close();
                    },
                  )
                ]),
                Text(trans(context, "specializations"), style: styles.mystyle),
                const SizedBox(height: 10),
                GridView.count(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    addRepaintBoundaries: true,
                    children: widget.specializations.map((Specialization item) {
                      return TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith<
                                    OutlinedBorder>(
                                (Set<MaterialState> states) =>
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(38.0),
                                    )),
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) => BorderSide(
                                color: selectedOptions.contains(item.id)
                                    ? colors.orange
                                    : colors.ggrey,
                              ),
                            ),
                            // textStyle:
                            //     MaterialStateProperty.resolveWith<TextStyle>(
                            //   (Set<MaterialState> states) => TextStyle(
                            //       color: selectedOptions.contains(item.id)
                            //           ? colors.orange
                            //           : colors.black,
                            //       fontSize: 16),
                            // )
                          ),
                          onPressed: () {
                            setState(() {
                              if (!selectedOptions.add(item.id)) {
                                selectedOptions.remove(item.id);
                              }
                            });
                          },
                          onLongPress: () {
                            Fluttertoast.showToast(
                                msg: item.name,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[300],
                                textColor: colors.orange,
                                fontSize: 16.0);
                          },
                          child: Text(item.name,
                              style: styles.mysmallforgridview));
                    }).toList()),
                const SizedBox(height: 15),
                TextFormInput(
                  text: trans(context, 'get_location'),
                  cController: locationController,
                  prefixIcon: Icons.my_location,
                  kt: TextInputType.visiblePassword,
                  readOnly: true,
                  onTab: () async {
                    Navigator.pushNamed(context, '/AutoLocate',
                        arguments: <String, dynamic>{
                          "lat": config.lat,
                          "long": config.long,
                          "choice": 1
                        });
                  },
                  obscureText: false,
                ),
            
                Row(
                  children: <Widget>[
                    Text(startingPrive.toString()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FlutterSlider(
                        handlerAnimation: const FlutterSliderHandlerAnimation(
                            curve: Curves.elasticOut,
                            reverseCurve: null,
                            duration: Duration(milliseconds: 700),
                            scale: 1.4),
                        values: <double>[startingPrive, endingPrive],
                        rangeSlider: true,
                        max: 500,
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBar: BoxDecoration(color: colors.orange),
                          activeTrackBarDraggable: true,
                          inactiveTrackBarHeight: 2,
                          activeTrackBarHeight: 3,
                        ),
                        jump: true,
                        min: 0,
                        selectByTap: true,
                        onDragging: (int handlerIndex, dynamic lowerValue,
                            dynamic upperValue) {
                          startingPrive = lowerValue as double;
                          endingPrive = upperValue as double;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(endingPrive.toString()),
                  ],
                ),
                Text(trans(context, "offer_history"), style: styles.mystyle),
                const SizedBox(height: 6),
                Text(trans(context, "accourding_offer_start_end_date"),
                    style: styles.mysmalllight),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _errorController = _scaffoldkey.currentState
                        .showBottomSheet<dynamic>((BuildContext context) {
                      SystemChannels.textInput
                          .invokeMethod<String>('TextInput.hide');
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    color: !showingStartingDateCalendar
                                        ? colors.grey
                                        : colors.trans,
                                    child: TextButton(
                                      autofocus: true,
                                      onPressed: () {
                                        _errorController.setState(() {
                                          showingStartingDateCalendar = true;
                                          t = tt;
                                        });
                                      },
                                      child: Text(trans(
                                          context, "offer_starting_date")),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    color: showingStartingDateCalendar
                                        ? colors.grey
                                        : colors.trans,
                                    child: TextButton(
                                      onPressed: () {
                                        _errorController.setState(() {
                                          showingStartingDateCalendar = false;
                                          t = ttt;
                                        });
                                      },
                                      child: Text(
                                          trans(context, "offer_ending_date")),
                                    )),
                              ),
                            ],
                          ),
                          const Divider(thickness: 2),
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: 430),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    child: child, scale: animation);
                              },
                              child: t),
                        ],
                      );
                    });
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                            (Set<MaterialState> states) =>
                                const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 11)),
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => colors.grey),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (Set<MaterialState> states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            side: BorderSide(color: Colors.grey[300]))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Icon(Icons.date_range, color: Colors.orange),
                      Text(trans(context, "offer_history"),
                          style: styles.searchDate),
                      Text(startDate, style: styles.searchDate),
                      Icon(Icons.arrow_forward, color: colors.orange),
                      Text(endDate, style: styles.searchDate),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(trans(context, "accourding_to_rating"),
                //         style: styles.mystyle),
                //     RatingBar(
                //       onRatingChanged: (double rating) {
                //         setState(() => _ratingStar = rating);
              
                //       },
                //       filledIcon: Icons.star,
                //       emptyIcon: Icons.star_border,
                //       halfFilledIcon: Icons.star_half,
                //       isHalfAllowed: true,
                //       filledColor: Colors.amberAccent,
                //       emptyColor: colors.grey,
                //       halfFilledColor: Colors.orange[300],
                //       size: 30,
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.resolveWith<
                                  EdgeInsetsGeometry>(
                              (Set<MaterialState> states) =>
                                  const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 25)),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) => colors.orange),
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (Set<MaterialState> states) =>
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Colors.grey)),
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(trans(context, "cancel"),
                          style: styles.notificationNO),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          padding:
                              MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                                  (Set<MaterialState> states) =>
                                      const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 25)),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) =>
                                      Colors.orange[600]),
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) =>
                                  BorderSide(color: Colors.orange[900])),
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (Set<MaterialState> states) =>
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Colors.grey)),
                          )),
                      onPressed: () {
                        getIt<SalesProvider>().setFilterDate(FilterData(
                          merchantNameOrPartOfit: merchantName.text??"",
                          saleNameOrPartOfit: saleName.text??"",
                          startingdate: starttoday??DateTime(2020,0,0),
                          endingdate: endtoday?? DateTime(2900,0,0),
                          // _ratingStar,
                          specifications: List<int>.from(selectedOptions)??<int>[1, 2],
                          fromPrice: startingPrive??0,
                          toPrice: endingPrive??9999,
                        ));

                        // .filterData =;
                        Navigator.popAndPushNamed(context, "/Home",
                            arguments: <String, dynamic>{
                              "salesDataFilter": true,
                              "filterDate":getIt<SalesProvider>().filterData
                            });
                      },

                      // textColor: colors.white,
                      child: Text(trans(context, "search"),
                          style: styles.notificationNO),
                    ),
                  ],
                )
              ],
            )));
  }
}
