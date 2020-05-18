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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (data != null) {
      data['data'] = mydata.toJson();
    }
    if (links != null) {
      data['links'] = links.toJson();
    }
    if (meta != null) {
      data['meta'] = meta.toJson();
    }
    return data;
  }
}

class Data {
  Data({this.id, this.name, this.logo, this.branches, this.sales});

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
    if (json['sales'] != null) {
      sales = <Sales>[];
      json['sales'].forEach((dynamic v) {
        sales.add(Sales.fromJson(v));
      });
    }
  }
  int id;
  String name;
  String logo;
  List<Branches> branches;
  List<Sales> sales;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    if (branches != null) {
      data['branches'] = branches.map((Branches v) => v.toJson()).toList();
    }
    if (sales != null) {
      data['sales'] = sales.map((Sales v) => v.toJson()).toList();
    }
    return data;
  }
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

class Sales {
  Sales(
      {this.id,
      this.name,
      this.oldPrice,
      this.price,
      this.startAt,
      this.endAt,
      this.details,
      this.status,
      this.mainImage,
      this.cropedImage});

  Sales.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    oldPrice = json['old_price'].toString();
    price = json['_price'].toString();
    startAt = json['start_at'].toString();
    endAt = json['end_at'].toString();
    details = json['details'].toString();
    status = json['status'].toString();
    mainImage = json['main_image'].toString();
    cropedImage = json['croped_image'].toString();
  }
  int id;
  String name;
  String oldPrice;
  String price;
  String startAt;
  String endAt;
  String details;
  String status;
  String mainImage;
  String cropedImage;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['old_price'] = oldPrice;
    data['_price'] = price;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['details'] = details;
    data['status'] = status;
    data['main_image'] = mainImage;
    data['croped_image'] = cropedImage;
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
