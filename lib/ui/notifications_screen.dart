import 'package:flutter/material.dart';
import '../localization/trans.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Notifcations extends StatefulWidget {
  const Notifcations({Key key}) : super(key: key);
  @override
  _NotifcationsState createState() => _NotifcationsState();
}

class _NotifcationsState extends State<Notifcations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'sales')),
        centerTitle: true,
      ),
      body: ListView.builder(
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
      ),
    );
  }

  Widget _itemBuilder(
    BuildContext c,
  ) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: <Widget>[
          IconSlideAction(
            caption: 'Archive',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Share',
            color: Colors.indigo,
            icon: Icons.share,
            onTap: () {},
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'More',
            color: Colors.black45,
            icon: Icons.more_horiz,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {},
          ),
        ],
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: const Text('3'),
            foregroundColor: Colors.white,
          ),
          title: const Text('Tile n°3'),
          subtitle: const Text('SlidableDrawerDelegate'),
        ),
      ),
    );
  }
}
