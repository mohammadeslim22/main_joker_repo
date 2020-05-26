import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/util/dio.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key key}) : super(key: key);

  @override
  AddressListState createState() => AddressListState();
}

class AddressListState extends State<AddressList> {
  Merchant merchant;
  Future<Merchant> getMerchantData(int id) async {
    final dynamic response = await dio.get<dynamic>("merchants/$id");

    merchant = Merchant.fromJson(response.data);
    return merchant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(trans(context, 'Address List')),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  "assets/images/address.png",
                  height: 130,
                  width: 130,
                ),
                const SizedBox(width: 30),
                Column(
                  children: <Widget>[
                    Text(trans(context, 'your address'),
                        style: styles.underHeadblack),
                    Text(trans(context, 'your address'), style: styles.mylight)
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              child: RaisedButton(
                  color: colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(trans(context, 'Add address'),
                          style: styles.underHeadwhite),
                      Icon(
                        Icons.add_circle_outline,
                        color: colors.white,
                      )
                    ],
                  ),
                  onPressed: () {}),
            ),
            FutureBuilder<Merchant>(
              future: getMerchantData(24),
              builder: (BuildContext ctx, AsyncSnapshot<Merchant> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //  return Container();
                  return Container(
                    width: 200,
                    child: ListView.builder(
                      itemCount: 0,
                      itemBuilder: (BuildContext context, int index) {
                        return AddressListItem();
                      },
                    ),
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent));
                }
              },
            ),
          ],
        ));
  }
}

class AddressListItem extends StatefulWidget {
  @override
  AddressListItemState createState() => AddressListItemState();
}

class AddressListItemState extends State<AddressList> {
  bool t;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Card(
        child: Row(
          children: <Widget>[
            Icon(Icons.not_listed_location),
            Column(
              children: <Widget>[
                Text(trans(context, 'your address'),
                    style: styles.underHeadblack),
                Text(trans(context, 'your address'), style: styles.mylight)
              ],
            ),
            if (t)
              Container()
            else
              CircleAvatar(backgroundColor: colors.ggrey, radius: 6)
          ],
        ),
      ),
    );
  }
}
