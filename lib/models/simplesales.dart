class SimpleSales {
  SimpleSales({this.data});

  SimpleSales.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <SimpleSalesData>[];
      json['data'].forEach((dynamic v) {
        data.add(SimpleSalesData.fromJson(v));
      });
    }
  }
  List<SimpleSalesData> data;
}

class SimpleSalesData {
  SimpleSalesData(
      {this.id,
      this.name,
      this.oldPrice,
      this.price,
      this.startAt,
      this.endAt,
      this.details,
      this.status,
      this.isliked,
      this.isfavorite});

  SimpleSalesData.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    oldPrice = json['old_price'].toString();
    price = json['_price'].toString();
    startAt = json['start_at'].toString();
    endAt = json['end_at'].toString();
    details = json['details'].toString();
    status = json['status'].toString();
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
  }
  int id;
  String name;
  String oldPrice;
  String price;
  String startAt;
  String endAt;
  String details;
  String status;
  int isliked;
  int isfavorite;
}
