
class Branches {
  Branches({this.data, this.links, this.meta});

  Branches.fromJson( dynamic json) {
    if (json['data'] != null) {
      data = <BranchData>[];
      json['data'].forEach((dynamic v) {
        data.add(BranchData.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<BranchData> data;
  Links links;
  Meta meta;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (data != null) {
      data['data'] = this.data.map((BranchData v) => v.toJson()).toList();
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

class BranchData {
  BranchData(
      {this.id,
      this.name,
      this.country,
      this.city,
      this.address,
      this.phone,
      this.sales,
      this.merchant});

  BranchData.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    address = json['address'] as String;
    phone = json['phone'] as String;
    if (json['sales'] != null) {
      sales = <Sales>[];
      json['sales'].forEach((dynamic v) {
        sales.add(Sales.fromJson(v));
      });
    }
    merchant =
         MerchantfromBranch.fromJson(json['merchant'] as Map<String, dynamic>);
  }
  int id;
  String name;
  Country country;
  City city;
  String address;
  String phone;
  List<Sales> sales;
  MerchantfromBranch merchant;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (country != null) {
      data['country'] = country.toJson();
    }
    if (city != null) {
      data['city'] = city.toJson();
    }
    data['address'] = address;
    data['phone'] = phone;
    if (sales != null) {
      data['sales'] = sales.map<dynamic>((Sales v) => v.toJson()).toList();
    }
    if (merchant != null) {
      data['merchant'] = merchant.toJson();
    }
    return data;
  }
}

class Country {
  Country({this.id, this.name});

  Country.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
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

class City {
  City({this.id, this.countryId, this.name});

  City.fromJson(dynamic json) {
    id = json['id'] as int;
    countryId = json['country_id'] as String;
    name = json['name'] as String;
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
  Sales({
    this.id,
    this.name,
    this.oldPrice,
    this.newPrice,
    this.startAt,
    this.endAt,
    this.details,
    this.status,
    this.mainImage,
    this.cropedImage,
    
  });

  Sales.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    oldPrice = json['old_price'] as String;
    newPrice = json['new_price'] as String;
    startAt = json['start_at'] as String;
    endAt = json['end_at'] as String;
    details = json['details'] as String;
    status = json['status'] as String;
    mainImage = json['main_image'] as String;
    cropedImage = json['croped_image'] as String;
   
  }
  int id;
  String name;
  String oldPrice;
  String newPrice;
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
    data['new_price'] = newPrice;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['details'] = details;
    data['status'] = status;
    data['main_image'] = mainImage;
    data['croped_image'] = cropedImage;
    return data;
  }
}

class MerchantfromBranch {
  MerchantfromBranch({this.id, this.name, this.logo});
  MerchantfromBranch.fromJson(dynamic json) {
    id =  json['id'] as int;
    name = json['name'].toString();
    logo = json['logo'] as String;
  }
  int id;
  String name;
  String logo;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    return data;
  }
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
