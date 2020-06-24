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
      this.images,
      this.merchant,
      this.isfavorite,
      this.isliked});

  SaleData.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    oldPrice = json['old_price'] as String;
    price = json[' price'] as String;
    startAt = json['start_at'] as String;
    endAt = json['end_at'] as String;
    details = json['details'] as String;
    status = json['status'] as String;
    mainImage = json['main_image'] as String;
    cropedImage = json['croped_image'] as String;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((dynamic v) {
        images.add(Images.fromJson(v));
      });
    }
    merchant = MerchantForSale.fromJson(json['merchant']);
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
  String mainImage;
  String cropedImage;
  List<Images> images;
  MerchantForSale merchant;
  int isliked;
  int isfavorite;
  
}

class MerchantForSale {
  MerchantForSale({this.id, this.name, this.logo,this.salesCount,this.ratesAverage});

  MerchantForSale.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    logo = json['logo'] as String;
    salesCount = json['sales_count']as int;
    ratesAverage = json['rates_average']as int;
  }


  int id;
  String name;
  String logo;
  int salesCount;
  int ratesAverage;
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

class Images {
  Images(
      {this.id,
      this.saleId,
      this.imageTitle,
      this.details,
      this.updatedAt,
      this.createdAt});

  Images.fromJson(dynamic json) {
    id = json['id'] as int;
    saleId = json['sale_id'].toString();
    imageTitle = json['image_title'].toString();
    details = json['details'].toString();
    updatedAt = json['updated_at'].toString();
    createdAt = json['created_at'].toString();
  }
  int id;
  String saleId;
  String imageTitle;
  String details;
  String updatedAt;
  String createdAt;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sale_id'] = saleId;
    data['image_title'] = imageTitle;
    data['details'] = details;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
