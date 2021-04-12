class Jnotification {
  Jnotification({this.data});

  Jnotification.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((dynamic v) {
        data.add(NotificationData.fromJson(v));
      });
    }
  }

  List<NotificationData> data;
}

class NotificationData {
  NotificationData(
      {this.id,
      this.userId,
      this.isread,
      this.message,
      this.title,
      this.image,
      this.period});

  NotificationData.fromJson(dynamic json) {
    id = json['id'] as int;
    userId = json['user_id'] as int;
    message = json['message'].toString();
    title = json['title'].toString();
     image = json['image'].toString();
    isread = json['isread'] as int;
    if (json['period'] != null) {
      period = <int>[];
      json['period'].forEach((dynamic v) {
        period.add(v as int);
      });
    }
  }
  int id;
  int userId;
  int isread;
  String message;
  String title;
  String image;
  List<int> period;
}
