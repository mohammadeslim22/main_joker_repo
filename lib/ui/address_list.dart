import 'package:flutter/material.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/styles.dart';

class AddressList extends StatefulWidget {
  AddressList({Key key}) : super(key: key);

  @override
  AddressListState createState() => AddressListState();
}

class AddressListState extends State<AddressList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trans(context, 'notifications')),centerTitle: true,
     
    ),
     body:Container()
    );
  }
}
