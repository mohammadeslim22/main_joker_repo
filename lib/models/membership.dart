import 'dart:ui';
import 'package:intl/intl.dart' as intl;

class MemberShip {
  MemberShip(
      {this.id,
      this.shopName,
      this.type,
      this.display,
      this.image,
      this.startingDate,
      this.endDtae});
  final int id;
  final String shopName;
  final String type;
  final Color display;
  final String image;
  final String startingDate;
  final String endDtae;
  static List<MemberShip> get membershipsData => <MemberShip>[
    
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
        MemberShip(
            id: 0,
            type: "شهري",
            image: "assets/images/qrcode.png",
            endDtae: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
            startingDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now())),
      ];
}
