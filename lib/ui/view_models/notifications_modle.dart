import 'dart:async';
import 'package:dio/dio.dart';
import 'package:joker/models/notification.dart';
import 'package:joker/util/dio.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'base_model.dart';

enum ViewState { Idle, Busy }

class NotificationsModel extends BaseModel {
  Jnotification jnotifications = Jnotification(data: <NotificationData>[]);
  List<bool> notificationSit = <bool>[true, false];
  int unredNotifications = 0;
  void setnotificationdCount(int count) {
    unredNotifications = count;
    notifyListeners();
  }

  Future<List<NotificationData>> getNotifications(int pageNumber) async {
    final Response<dynamic> response = await dio.get<dynamic>("notifications",
        queryParameters: <String, int>{"page": pageNumber + 1});
    jnotifications = Jnotification.fromJson(response.data);
    notifyListeners();
    return jnotifications.data;
  }

  PagewiseLoadController<dynamic> pagewiseNotificationsController;
  Future<void> getNotificationsCount() async {

    if (dio.options.headers['authorization'] != null &&
        dio.options.headers['authorization'].toString().trim() == "" &&
        dio.options.headers['authorization'].toString().trim() == "null" &&
        dio.options.headers['authorization'].toString().isNotEmpty) {
      final Response<dynamic> res = await dio
          .get<dynamic>("notif_count", queryParameters: <String, String>{
        "token":
            dio.options.headers['authorization'].toString().split(" ")[1] ?? ""
      });
      if (res.data.toString() == "unauthinicated") {
      } else {
        setnotificationdCount(int.parse(res.data.toString()));
      }
    }
  }


  Future<void> openNotifications(int nId) async {
    await dio.post<dynamic>("notifications",
        queryParameters: <String, dynamic>{"id": nId});
    jnotifications.data.firstWhere((NotificationData element) {
      return element.id == nId;
    }).isread = 1;
    minnotificationdCount1();
    notifyListeners();
  }

  void minnotificationdCount1() {
    unredNotifications--;
    notifyListeners();
  }
}
