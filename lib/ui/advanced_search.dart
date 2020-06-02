import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/providers/counter.dart';
import 'package:joker/util/dio.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import '../models/search_model.dart';
import '../localization/trans.dart';
import '../constants/styles.dart';
import 'widgets/text_form_input.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/util/functions.dart';
import 'package:flutter/services.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key key}) : super(key: key);
  @override
  AdvanceSearchscreen createState() => AdvanceSearchscreen();
}

class AdvanceSearchscreen extends State<AdvancedSearch>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  List<Specializations> specializations = <Specializations>[];
  Future<List<Specializations>> getSpecializationsData() async {
    final dynamic response = await dio.get<dynamic>("specializations");
    specializations.clear();
    response.data.forEach((dynamic element) {
      
      specializations.add(Specializations.fromJson(element));
    });
    return specializations;
  }

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
              title: Text(
                trans(context, "advanced_search"),
                style: styles.mystyle,
              )),
          body: FutureBuilder<List<Specializations>>(
            future: getSpecializationsData(),
            builder: (BuildContext ctx,
                AsyncSnapshot<List<Specializations>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Page(
                  scaffoldkey: _scaffoldkey,
                  specializations: specializations,
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent));
              }
            },
          ),
        ));
  }
}

class Page extends StatefulWidget {
  const Page({Key key, this.scaffoldkey, this.specializations})
      : super(key: key);

  @override
  _PageState createState() => _PageState();
  final GlobalKey<ScaffoldState> scaffoldkey;
  final List<Specializations> specializations;
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  Set<int> selectedOptions = <int>{};
  PersistentBottomSheetController<dynamic> _errorController;
  static DateTime starttoday = DateTime.now();
  static DateTime endtoday = DateTime.now();
  String startDate = "${starttoday.toLocal()}".split(' ')[0];
  String endDate = "${endtoday.toLocal()}".split(' ')[0];
  AnimationController _animationController;
  final CalendarController _calendarController = CalendarController();
  double _ratingStar = 0;
  bool showingStartingDateCalendar = true;
  Widget t;
  Widget tt;
  Widget ttt;

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

  void _onDaySelected(DateTime day, List<void> events) {
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
    print('CALLBACK: _onDaySelected');
  }

  String selectedValue;
  final TextEditingController merchantName = TextEditingController();
  final TextEditingController saleName = TextEditingController();
  final FocusNode globalFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final MyCounter bolc = Provider.of<MyCounter>(context);
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text(trans(context, "search_through"), style: styles.mystyle),
        const SizedBox(height: 10),
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
        const SizedBox(height: 20),
        Text(trans(context, "specializations"), style: styles.mystyle),
        const SizedBox(height: 10),
        GridView.count(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            primary: true,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 4,
            childAspectRatio: 2,
            addRepaintBoundaries: true,
            children: widget.specializations.map((Specializations item) {
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
                        msg: item.name,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[300],
                        textColor: colors.orange,
                        fontSize: 16.0);
                  },
                  child: Text(item.name, style: styles.mysmallforgridview));
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
                setState(() {
                  config.locationController.text = "Tap to set my location";
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
              Text(startDate),
              Icon(
                Icons.arrow_forward,
                color: colors.orange,
              ),
              Text(endDate),
            ],
          ),
          onPressed: () {
            _errorController = widget.scaffoldkey.currentState
                .showBottomSheet<dynamic>((BuildContext context) {
              SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
              return Container(
                  height: 395,
                  child: Column(
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
                              child: FlatButton(
                                autofocus: true,
                                onPressed: () {
                                  _errorController.setState(() {
                                    showingStartingDateCalendar = true;
                                    t = tt;
                                  });
                                },
                                child:
                                    Text(trans(context, "offer_starting_date")),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: showingStartingDateCalendar
                                  ? colors.grey
                                  : colors.trans,
                              child: FlatButton(
                                onPressed: () {
                                  _errorController.setState(() {
                                    showingStartingDateCalendar = false;
                                    t = ttt;
                                  });
                                },
                                child:
                                    Text(trans(context, "offer_ending_date")),
                              ),
                            ),
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
                  ));
            });
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.grey)),
              onPressed: () {},
              color: colors.ggrey,
              textColor: colors.white,
              child:
                  Text(trans(context, "cancel"), style: styles.notificationNO),
            ),
            RaisedButton(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.red)),
              onPressed: () {
                
                Navigator.pushNamed(context, "/Home",
                    arguments: <String, dynamic>{
                      "salesDataFilter": true,
                      "FilterData": FilterData(
                          merchantName.text,
                          saleName.text,
                          starttoday,
                          endtoday,
                          config.lat,
                          config.long,
                          _ratingStar,
                          List<int>.from(selectedOptions) 
                          )
                    });
              },
              color: Colors.red,
              textColor: colors.white,
              child:
                  Text(trans(context, "search"), style: styles.notificationNO),
            ),
          ],
        )
      ],
    );
  }
}
