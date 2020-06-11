class Merchant {
  Merchant({this.mydata, this.links, this.meta});

  Merchant.fromJson(dynamic json) {
    mydata = json['data'] != null ? Data.fromJson(json['data']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  Data mydata;
  Links links;
  Meta meta;
}

class Data {
  Data({this.id, this.name, this.logo, this.branches, this.salesCount,this.likesCount});

  Data.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    logo = json['logo'].toString();
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((dynamic v) {
        branches.add(Branches.fromJson(v));
      });
    }
    if (json['sales_count'] != null) {
      salesCount = json['sales_count'] as int;
    } else {
      salesCount = 0;
    }
       if (json['likes_count'] != null) {
      likesCount = json['likes_count'] as int;
    } else {
      likesCount = 0;
    }
  }
  int id;
  String name;
  String logo;
  List<Branches> branches;
  int salesCount;
  int likesCount;
}

class Branches {
  Branches(
      {this.id,
      this.name,
      this.countryId,
      this.cityId,
      this.address,
      this.phone});

  Branches.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    countryId = json['country_id'] != null
        ? CountryId.fromJson(json['country_id'])
        : null;
    cityId = json['city_id'] != null ? CityId.fromJson(json['city_id']) : null;
    address = json['address'].toString();
    phone = json['phone'].toString();
  }
  int id;
  String name;
  CountryId countryId;
  CityId cityId;
  String address;
  String phone;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (countryId != null) {
      data['country_id'] = countryId.toJson();
    }
    if (cityId != null) {
      data['city_id'] = cityId.toJson();
    }
    data['address'] = address;
    data['phone'] = phone;
    return data;
  }
}

class CountryId {
  CountryId({this.id, this.name});

  CountryId.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }
  int id;
  String name;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class CityId {
  CityId({this.id, this.countryId, this.name});

  CityId.fromJson(dynamic json) {
    id = json['id'] as int;
    countryId = json['country_id'].toString();
    name = json['name'].toString();
  }
  int id;
  String countryId;
  String name;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['name'] = name;
    return data;
  }
}

class Links {
  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(dynamic json) {
    first = json['first'].toString();
    last = json['last'].toString();
    prev = json['prev'].toString();
    next = json['next'].toString();
  }
  String first;
  String last;
  String prev;
  String next;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first'] = first;
    data['last'] = last;
    data['prev'] = prev;
    data['next'] = next;
    return data;
  }
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
    path = json['path'].toString();
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['path'] = path;
    data['per_page'] = perPage;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}
