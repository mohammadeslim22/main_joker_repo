class Sales {
  Sales({this.data, this.links, this.meta});

  Sales.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <SaleData>[];
      json['data'].forEach((dynamic v) {
        data.add(SaleData.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<SaleData> data;
  Links links;
  Meta meta;
  dynamic toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.map((SaleData v) => v.toJson()).toList();
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

class SaleData {
  SaleData(
      {this.id,
      this.name,
      this.oldPrice,
      this.price,
      this.startAt,
      this.endAt,
      this.details,
      this.status,
      this.mainImage,
      this.cropedImage,
      this.merchant});

  SaleData.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    oldPrice = json['old_price'] as String;
    price = json[' _price'] as String;
    startAt = json['start_at'] as String;
    endAt = json['end_at'] as String;
    details = json['details'] as String;
    status = json['status'] as String;
    mainImage = json['main_image'] as String;
    cropedImage = json['croped_image'] as String;
    merchant = MerchantForSale.fromJson(json['merchant']);
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
  MerchantForSale merchant;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['old_price'] = oldPrice;
    data[' _price'] = price;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['details'] = details;
    data['status'] = status;
    data['main_image'] = mainImage;
    data['croped_image']=cropedImage;
    data['merchant']=cropedImage;
    return data;
  }
}

class MerchantForSale {
  MerchantForSale({this.id, this.name, this.logo});

  MerchantForSale.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    logo = json['logo'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    return data;
  }

  int id;
  String name;
  String logo;
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
