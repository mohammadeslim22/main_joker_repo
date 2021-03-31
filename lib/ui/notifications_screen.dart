import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joker/models/notification.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:joker/util/service_locator.dart';
import 'package:provider/provider.dart';
import '../localization/trans.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/styles.dart';
import 'package:dio/dio.dart';
import 'package:joker/util/dio.dart';

class Notifcations extends StatefulWidget {
  const Notifcations({Key key}) : super(key: key);
  @override
  _NotifcationsState createState() => _NotifcationsState();
}

class _NotifcationsState extends State<Notifcations> {
  Jnotification n;
  // Future<List<NotificationData>> getNotifications() async {
  //   final Response<dynamic> response = await dio.get<dynamic>("notifications");
  //   n = Jnotification.fromJson(response.data);
  //   return n.data;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(trans(context, 'notifications'), style: styles.appBars),
            centerTitle: true),
        body: Consumer<MainProvider>(
            builder: (BuildContext context, MainProvider value, Widget child) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            shrinkWrap: true,
            itemCount: value.n.data.length,
            addRepaintBoundaries: true,
            itemBuilder: (BuildContext context, int index) {
              return AnimatedCard(
                direction: AnimatedCardDirection.left,
                initDelay: const Duration(milliseconds: 0),
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
                child: _itemBuilder(context, value.n.data[index]),
              );
            },
          );
        }));
  }

  Widget _itemBuilder(BuildContext c, NotificationData nD) {
    String endsIn = "";
    print(nD.period);
    if (nD.period is! String) {
      final String yearsToEnd = nD.period[0] != 0
          ? nD.period[0].toString() + " " + trans(context, 'year') + ","
          : "";
      final String monthsToEnd = nD.period[1] != 0
          ? nD.period[1].toString() + " " + trans(context, 'month') + ","
          : "";
      final String daysToEnd = nD.period[2] != 0
          ? nD.period[2].toString() + " " + trans(context, 'day') + ","
          : "";
      final String hoursToEnd = nD.period[3] != 0
          ? nD.period[3].toString() + " " + trans(context, 'hour') + ","
          : "";
      final String minutesToEnd = nD.period[4] != 0
          ? nD.period[4].toString() + " " + trans(context, 'minute') + "."
          : "";
      endsIn = "$yearsToEnd $monthsToEnd $daysToEnd $hoursToEnd $minutesToEnd";
    } else {
      endsIn = nD.period.toString();
    }
    return Dismissible(
      key: const Key("c"),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: ListTile(
          leading: Visibility(
            visible: nD.image == null,
            child: SvgPicture.asset('assets/images/notification.svg'),
            replacement: CachedNetworkImage(imageUrl: nD.image),
          ),
          title: Text(nD.title),
          subtitle: Text(nD.message),
          trailing: Text("${trans(context, 'since:')} : $endsIn"),
        ),
      ),
    );
  }
}

class NoNotificationsToday extends StatelessWidget {
  const NoNotificationsToday({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/no_notification.svg',
          ),
          Text(trans(context, 'no_notifications_yet'),
              style: styles.underHeadblack),
        ],
      ),
    );
  }
}
