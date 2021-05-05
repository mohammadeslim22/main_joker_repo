import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/models/notification.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:provider/provider.dart';
import '../localization/trans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/styles.dart';

class Notifcations extends StatefulWidget {
  const Notifcations({Key key}) : super(key: key);
  @override
  _NotifcationsState createState() => _NotifcationsState();
}

class _NotifcationsState extends State<Notifcations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppBar(
          title: Text(trans(context, 'notifications'), style: styles.appBars),
          centerTitle: true),
      body: Consumer<MainProvider>(
        builder: (BuildContext context, MainProvider value, Widget child) {
          return PagewiseListView<dynamic>(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            loadingBuilder: (BuildContext context) {
              return const Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent));
            },
            pageLoadController: value.pagewiseNotificationsController,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, dynamic entry, int index) {
              return _itemBuilder(context, entry as NotificationData, value);
            },
            noItemsFoundBuilder: (BuildContext context) {
              return const NoNotificationsToday();
            },
          );

          // ListView.builder(
          //   padding: const EdgeInsets.symmetric(vertical: 0),
          //   shrinkWrap: true,

          //   itemCount: value.n.data.length,
          //   addRepaintBoundaries: true,
          //   itemBuilder: (BuildContext context, int index) {

          //     return Container(
          //       margin: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
          //       child: AnimatedCard(
          //         direction: AnimatedCardDirection.left,
          //         initDelay: const Duration(milliseconds: 0),
          //         duration: const Duration(seconds: 1),
          //         curve: Curves.ease,
          //         child: _itemBuilder(context, value.n.data[index], value),
          //       ),
          //     );
          //   },
          // );
        },
      ),
    );
  }

  Widget _itemBuilder(BuildContext c, NotificationData nD, MainProvider value) {
    String endsIn = "";
    if (nD.period is! String) {
      final String yearsToEnd = nD.period[0] != 0
          ? nD.period[0].toString() + " " + trans(context, 'y') + ","
          : "";
      final String monthsToEnd = nD.period[1] != 0
          ? nD.period[1].toString() + " " + trans(context, 'm') + ","
          : "";
      final String daysToEnd = nD.period[2] != 0
          ? nD.period[2].toString() + " " + trans(context, 'd') + ","
          : "";
      final String hoursToEnd = nD.period[3] != 0
          ? nD.period[3].toString() + " " + trans(context, 'h') + ","
          : "";
      final String minutesToEnd = nD.period[4] != 0
          ? nD.period[4].toString() + " " + trans(context, 'm') + "."
          : "";
      endsIn = "$yearsToEnd $monthsToEnd $daysToEnd $hoursToEnd $minutesToEnd";
    } else {
      endsIn = nD.period.toString();
    }
    return Dismissible(
      onDismissed: (DismissDirection dDirection) async {
        if (nD.isread == 0){
           await value.openNotifications(nD.id);
        }
      },
      key: const Key("c"),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: ListTile(
          tileColor: nD.isread == 1 ? colors.grey : colors.white,
          leading: Visibility(
            visible: nD.image == "",
            child: SvgPicture.asset('assets/images/notification.svg'),
            replacement: CachedNetworkImage(
                imageUrl: nD.image, fit: BoxFit.cover, height: 50, width: 50),
          ),
          title: Text(nD.title),
          subtitle: Text(nD.message),
          trailing: Visibility(
            visible: nD.isread == 0,
            child: Text(endsIn),
            replacement: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("${trans(context, 'read')}"),
                const Icon(Icons.check_circle_outline, color: Colors.orange)
              ],
            ),
          ),
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
