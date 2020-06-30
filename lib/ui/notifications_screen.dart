import 'package:flutter/material.dart';
import '../localization/trans.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  Future<String> getNotifications() async {
    final Response<dynamic> response = await dio.get<dynamic>("sales");
    return response.data.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(trans(context, 'notifications')),
          centerTitle: true,
        ),
        body: FutureBuilder<String>(
            future: getNotifications(),
            builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.isEmpty) {}
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shrinkWrap: true,
                  itemCount: 60,
                  addRepaintBoundaries: true,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimatedCard(
                      direction: AnimatedCardDirection.left,
                      initDelay: const Duration(milliseconds: 0),
                      duration: const Duration(seconds: 1),
                      curve: Curves.ease,
                      child: _itemBuilder(context),
                    );
                  },
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                ));
              }
            }));
  }

  Widget _itemBuilder(
    BuildContext c,
  ) {
    return Dismissible(
      key: const Key("c"),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: ListTile(
          leading: SvgPicture.asset(
            'assets/images/notification.svg',
          ),
          title: const Text('Tile n°3'),
          subtitle: const Text('SlidableDrawerDelegate'),
          trailing: Text(trans(context, 'since:')),
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
