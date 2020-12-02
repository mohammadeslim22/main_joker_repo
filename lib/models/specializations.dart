class Specialization {
  Specialization({this.id, this.name});

  Specialization.fromJson(dynamic json) {
    id = json['id'] as int;
    name = capitalize(json['name'].toString());
  }

  int id;
  String name;
String capitalize(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}
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
