import 'package:animated_card/animated_card.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/models/merchant_memberships.dart';
import 'package:joker/util/dio.dart';
import '../localization/trans.dart';
import 'package:joker/ui/widgets/custom_toast_widget.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class MemberShipsForMerchant extends StatefulWidget {
  const MemberShipsForMerchant({Key key, this.merchantId}) : super(key: key);
  final int merchantId;
  @override
  _MemberShipsForMerchantState createState() => _MemberShipsForMerchantState();
}

class _MemberShipsForMerchantState extends State<MemberShipsForMerchant> {
  MerchantMemberShip memberShips;
  Future<List<MemFromMerchant>> getMemebershipsData(int id) async {
    final Response<dynamic> response =
        await dio.get<dynamic>("memberships?merchant_id=$id");
    print("here in membership screen, ${response.data}");
    memberShips = MerchantMemberShip.fromJson(response.data);
    return memberShips.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'Merchant MemberShips')),
      ),
      body: FutureBuilder<List<MemFromMerchant>>(
          future: getMemebershipsData(widget.merchantId),
          builder: (BuildContext ctx,
              AsyncSnapshot<List<MemFromMerchant>> snapshot) {
            if (snapshot.data == null) {
              return Center(child: Text(trans(context, 'nothing_to_show')));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                shrinkWrap: true,
                itemCount: memberShips.data.length,
                addRepaintBoundaries: true,
                itemBuilder: (BuildContext context, int index) {
                  return AnimatedCard(
                    direction: AnimatedCardDirection.left,
                    initDelay: const Duration(milliseconds: 0),
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease,
                    child: _itemBuilder(memberShips.data[index]),
                  );
                },
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ));
            }
          }),
    );
  }

  Widget _itemBuilder(MemFromMerchant memFromMerchant) {
    final ExpandableController exp = ExpandableController();
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: ExpandableNotifier(
            controller: exp,
            child: ExpandablePanel(
              iconColor: Colors.orange,
              controller: exp,
              header: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(memFromMerchant.merchant),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(memFromMerchant.title),
                        Column(
                          children: <Widget>[
                            Text(trans(context, 'age') +
                                ": " +
                                memFromMerchant.ageStage),
                            const SizedBox(height: 6),
                            Text(trans(context, 'type') +
                                ": " +
                                memFromMerchant.type),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(memFromMerchant.message),
                    FlatButton(
                      color: Colors.orange,
                      onPressed: () {
                        exp.toggle();
                        dio.post<dynamic>("usermemberships",
                            queryParameters: <String, dynamic>{
                              "membership_id": memFromMerchant.id
                            }).then((Response<dynamic> value) {
                          showToastWidget(
                              IconToastWidget.success(
                                  msg: trans(context, 'request_sent_successfully')),
                              context: context,
                              position: StyledToastPosition.center,
                              animation: StyledToastAnimation.slideFromTop,
                              reverseAnimation: StyledToastAnimation.fade,
                              duration: const Duration(seconds: 4),
                              animDuration: const Duration(seconds: 1),
                              curve: Curves.elasticOut,
                              reverseCurve: Curves.linear);
                        });
                      },
                      child: Text(trans(context, 'join'),
                          style: styles.mywhitestyle),
                    )
                  ],
                ),
              ),
              // ignore: deprecated_member_use
              tapHeaderToExpand: true,
              // ignore: deprecated_member_use
              hasIcon: true,
            )));
  }
}
