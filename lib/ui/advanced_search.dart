import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rating_bar/rating_bar.dart';
import '../models/search_model.dart';
import '../localization/trans.dart';
import '../constants/styles.dart';
import 'widgets/textforminput.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key key}) : super(key: key);
  @override
  AdvanceSearchscreen createState() => AdvanceSearchscreen();
}

class AdvanceSearchscreen extends State<AdvancedSearch>
    with TickerProviderStateMixin {
  Set<int> selectedOptions = <int>{};

  static DateTime today = DateTime.now();
  String selectedValue;
  final TextEditingController merchantName = TextEditingController();
  final TextEditingController saleName = TextEditingController();

  final List<SearchModel> options = SearchModel.searchData;
  double _ratingStar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans(context, "advanced_search"),
            style: styles.mystyle,
          )),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
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
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
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
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  color: Colors.white,
                  textColor: selectedOptions.contains(item.id)
                      ? Colors.red
                      : Colors.black,
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
                        textColor: Colors.orange,
                        fontSize: 16.0);
                  },
                  child: Text(
                    item.search,
                    style: styles.mysmall,
                  ),
                );
              }).toList()),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              // TODO(isleem): put map here
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            trans(
              context,
              "offer_history",
            ),
            style: styles.mystyle,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            trans(
              context,
              "accourding_offer_start_end_date",
            ),
            style: styles.mysmalllight,
          ),
          const SizedBox(
            height: 10,
          ),
          RaisedButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
                side: BorderSide(color: Colors.grey[300])),
            color: Colors.white,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.date_range,
                ),
                Text(
                  trans(
                    context,
                    "offer_history",
                  ),
                  style: styles.mysmalllight,
                ),
                Text("${today.toLocal()}".split(' ')[0]),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.orange,
                ),
                Text("${today.toLocal()}".split(' ')[0]),
              ],
            ),
            onPressed: () {},
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                trans(
                  context,
                  "accourding_to_rating",
                ),
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
          const SizedBox(
            height: 15,
          ),
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
                child: Text(
                    trans(
                      context,
                      "cancel",
                    ),
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
                textColor: Colors.white,
                child: Text(
                    trans(
                      context,
                      "search",
                    ),
                    style: styles.notificationNO),
              ),
            ],
          )
        ],
      ),
    );
  }
}
