class Branches {
  Branches({this.data, this.links, this.meta});

  Branches.fromJson(dynamic json) {
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
}

class BranchData {
  BranchData(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.address,
      this.phone,
      this.salesCount,
      this.merchant,
      this.isliked,
      this.isfavorite});

  BranchData.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    latitude =double.parse( json['latitude'].toString());
    
    longitude = double.parse( json['longitude'].toString());
    address = json['address'] as String;
    phone = json['phone'] as String;
   // salesCount = json['sales'] as int;
    merchant =
        MerchantfromBranch.fromJson(json['merchant'] as Map<String, dynamic>);
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
  }
  int id;
  String name;
  double latitude;
  double longitude;
  String address;
  String phone;
  int salesCount;
  MerchantfromBranch merchant;
  int isliked;
  int isfavorite;
  int sales;
}

class MerchantfromBranch {
  MerchantfromBranch({this.id, this.name, this.logo, this.rateAverage});
  MerchantfromBranch.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    logo = json['logo'] as String;
    rateAverage = json['rates_average'] as int;
  }
  int id;
  String name;
  String logo;
  int rateAverage;
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
