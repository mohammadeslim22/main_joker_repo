class Locations {
  Locations({this.data, this.links, this.meta});

  Locations.fromJson( dynamic json) {
    if (json['data'] != null) {
      data = <LocationsData>[];
      json['data'].forEach((dynamic v) {
        data.add(LocationsData.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  List<LocationsData> data;
  Links links;
  Meta meta;
}

class LocationsData {
  LocationsData(
      {this.id,
      this.email,
      this.phone,
      this.address,
      this.latitude,
      this.longitude,
      this.createdAt});

  LocationsData.fromJson(dynamic json) {

    id = json['id'] as int;
    email = json['email'].toString();
    phone = json['phone'].toString();
    address = json['address'].toString();
    latitude = json['latitude'].toString()=='null'? 0.0 : double.parse(json['latitude'].toString());
    longitude = json['longitude'].toString()=='null'? 0.0 : double.parse(json['longitude'].toString());
    createdAt = json['created_at'].toString();
  }
  int id;
  String email;
  String phone;
  String address;
  double latitude;
  double longitude;
  String createdAt;
}

class Links {
  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(dynamic json) {
    first = json['first'] as String;
    last = json['last'] as String;
    prev = json['prev'] as String;
    next = json['next'] as String;
  }
  String first;
  String last;
  String prev;
  String next;
}

class Meta {
  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(dynamic json) {
    currentPage = json['current_page'] as int;
    from = json['from'] as int;
    lastPage = json['last_page'] as int;
    path = json['path'] as String;
    perPage = json['per_page'] as int;
    to = json['to'] as int;
    total = json['total'] as int;
  }
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;
}
