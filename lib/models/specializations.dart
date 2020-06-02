class Specializations {
  Specializations({this.id, this.name, this.status});

  Specializations.fromJson(dynamic json) {
    id = json['id']as int;
    name = json['name'].toString();
    status = json['status'].toString();
      }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    return data;
  }

  int id;
  String name;
  String status;
}
