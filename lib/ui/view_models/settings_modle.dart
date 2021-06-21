import 'package:joker/providers/language.dart';
import 'package:joker/util/data.dart';
import 'package:joker/util/dio.dart';
import 'package:joker/util/service_locator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'base_model.dart';

class SettingsModle extends BaseModel {
  // List<bool> fontlist = <bool>[false, true, false];
  List<bool> language = <bool>[false, false, false];
  int favocurrentIndex = 0;
  bool _visible = true;
  bool __visible = false;
  List<bool> notificationSit = <bool>[true, false];
  bool notificationSound = true;

  Future<void> getSettingsReady() async {
    setNotifcationSound();
    final String notificationAlowed =
        await data.getData("notification_receive");
    final String lang = await data.getData("ilang");
    final int langIndex = lang == "ar"
        ? 0
        : lang == "en"
            ? 1
            : 2;
    changenotificationSit(notificationAlowed == "on" ? 0 : 1);
    changelanguageindex(langIndex);
  }

  Future<void> changenotificationSit(int state) async {
    notificationSit = state == 0 ? <bool>[true, false] : <bool>[false, true];
    notifyListeners();
    await data.setData("notification_receive", state == 0 ? "on" : "off");
  }

  Future<void> toggleNotificationSound(bool value) async {
    notificationSound = !notificationSound;
    notifyListeners();
    dio.post<dynamic>("settings",
        data: <String, dynamic>{'recieve_notify': value ? "on" : "off"});
    await data.setData("notification_sound", notificationSound ? "on" : "off");
  }

  Future<void> setNotifcationSound() async {
    data.getData("notification_sound").then<dynamic>((String value) async {
      if (value.isEmpty || value == "" || value == null || value == "on") {
        notificationSound = true;
        OneSignal.shared
            .setInFocusDisplayType(OSNotificationDisplayType.notification);
        changenotificationSit(0);
      } else {
        if (value == "off") {
          notificationSound = false;
          OneSignal.shared
              .setInFocusDisplayType(OSNotificationDisplayType.none);
          changenotificationSit(1);
        }
      }
    });
  }

  void changeTabBarIndex(int id) {
    favocurrentIndex = id;
    _visible = !_visible;
    __visible = !__visible;
    notifyListeners();
  }

  void changelanguageindex(int index) {
    for (int i = 0; i < language.length; i++) {
      if (i == index) {
        language[i] = true;
      } else {
        language[i] = false;
      }
    }

    notifyListeners();
  }
}
