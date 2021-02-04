class Sales {
  Sales({this.data});

  Sales.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <SaleData>[];
      json['data'].forEach((dynamic v) {
        data.add(SaleData.fromJson(v));
      });
    }
  }
  List<SaleData> data;
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
      this.isliked,
      this.branches,
      this.discount,
      this.startPeriod});

  SaleData.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    oldPrice = json['old_price'].toString();
    price = json['new_price'].toString();
    discount = json['discount'].toString();
    startAt = json['start_at'].toString();

    if (json['period'] != null) {
      if (json['period'] is String) {
        period = json['period'].toString();
      } else {
        period = <int>[];
        json['period'].forEach((dynamic v) {
          period.add(v as int);
        });
      }
    }
    endAt = json['end_at'].toString();
    details = json['details'].toString();
    status = json['status'].toString();
    mainImage = json['main_image'] as String;
    cropedImage = json['croped_image'] as String;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((dynamic v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json['merchant'] != null)
      merchant = MerchantForSale.fromJson(json['merchant']);
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
    if (json['branches'] != null) {
      branches = <BranchesMini>[];
      json['branches'].forEach((dynamic v) {
        branches.add(BranchesMini.fromJson(v));
      });
    }
    if (json['start_period'] != null) {
      startPeriod = <int>[];
      json['start_period'].forEach((dynamic v) {
        startPeriod.add(v as int);
      });
    }
  }

  int id;
  String name;
  String oldPrice;
  String price;
  String discount;
  String startAt;
  dynamic period;
  String endAt;
  String details;
  String status;
  String mainImage;
  String cropedImage;
  List<Images> images;
  MerchantForSale merchant;
  int isliked;
  int isfavorite;
  List<BranchesMini> branches;
  List<int> startPeriod;
}

class BranchesMini {
  BranchesMini({this.id, this.name});

  BranchesMini.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
  }

  int id;
  String name;
}

class MerchantForSale {
  MerchantForSale(
      {this.id, this.name, this.logo, this.salesCount, this.ratesAverage});

  MerchantForSale.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    logo = json['logo'] as String;
    salesCount = json['sales_count'] as int;
    ratesAverage = json['rates_average'] as int;
  }

  int id;
  String name;
  String logo;
  int salesCount;
  int ratesAverage;
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
