class MapBranches {
  MapBranches({this.mapBranches});

  MapBranches.fromJson(dynamic json) {
    if (json['data'] != null) {
      mapBranches = <MapBranch>[];
      json['data'].forEach((dynamic v) {
        mapBranches.add(MapBranch.fromJson(v));
      });
    }
  }
  List<MapBranch> mapBranches;
}

class MapBranch {
  MapBranch(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.latitude,
      this.longitude,
      this.ratesCount,
      this.likesCount,
      this.isliked,
      this.isfavorite,
      this.twoSales,
      this.merchant});

  MapBranch.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    address = json['address'].toString();
    phone = json['phone'].toString();
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
    ratesCount = json['rates_count'] as int;
    likesCount = json['likes_count'] as int;
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
    if (json['sales'] != null) {
      twoSales = <TwoSales>[];
      json['sales'].forEach((dynamic v) {
        twoSales.add(TwoSales.fromJson(v));
      });
    }
    merchant =
        json['merchant'] != null ? Merchant.fromJson(json['merchant']) : null;
  }
  int id;
  String name;
  String address;
  String phone;
  double latitude;
  double longitude;
  int ratesCount;
  int likesCount;
  int isliked;
  int isfavorite;  List<TwoSales> twoSales;
  Merchant merchant;
}

class TwoSales {
  TwoSales(
      {this.id,
      this.userId,
      this.name,
      this.oldPrice,
      this.newPrice,
      this.startAt,
      this.endAt,
      this.details,
      this.merchantId,
      this.status,
      this.mainImage,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  TwoSales.fromJson(dynamic json) {
    id = json['id'] as int;
    userId = json['user_id'].toString();
    name = json['name'].toString();
    oldPrice = json['old_price'].toString();
    newPrice = json['new_price'].toString();
    startAt = json['start_at'].toString();
    endAt = json['end_at'].toString();
    details = json['details'].toString();
    merchantId = json['merchant_id'].toString();
    status = json['status'].toString();
    mainImage = json['main_image'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }
  int id;
  String userId;
  String name;
  String oldPrice;
  String newPrice;
  String startAt;
  String endAt;
  String details;
  String merchantId;
  String status;
  String mainImage;
  String createdAt;
  String updatedAt;
  Pivot pivot;
}

class Pivot {
  Pivot({this.branchId, this.saleId});

  Pivot.fromJson(dynamic json) {
    branchId = json['branch_id'].toString();
    saleId = json['sale_id'].toString();
  }
  String branchId;
  String saleId;
}

class Merchant {
  Merchant({this.id, this.name, this.logo, this.ratesAverage, this.salesCount});

  Merchant.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    logo = json['logo'].toString();
    ratesAverage = json['rates_average'] as int;
    salesCount = json['sales_count'] as int;
  }
  int id;
  String name;
  String logo;
  int ratesAverage;
  int salesCount;
}
