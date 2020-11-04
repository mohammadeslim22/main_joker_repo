class Specialization {
  Specialization({this.id, this.name});

  Specialization.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }

  int id;
  String name;
}

class Specializations {
  Specializations({this.data});

  Specializations.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <Specialization>[];
      json['data'].forEach((dynamic v) {
        data.add(Specialization.fromJson(v));
      });
    }
  }
  List<Specialization> data;
}
