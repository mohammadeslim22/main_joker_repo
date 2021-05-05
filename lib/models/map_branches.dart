import 'package:joker/models/sales.dart';

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
      this.salesCount,
      this.merchant,
      this.spec,
      this.rateAverage,
      this.lastsales});

  MapBranch.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    address = json['address'].toString();
    phone = json['phone'].toString();
    if (json['latitude'] != null) {
      latitude = double.parse(json['latitude'].toString());
    }
    if (json['longitude'] != null) {
      longitude = double.parse(json['longitude'].toString());
    }
    // latitude = double.parse(json['latitude'].toString());

    ratesCount = json['rates_count'] as int;
    likesCount = json['likes_count'] as int;
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
    if (json['sales'] != null) {
      salesCount = json['sales'] as int;
    }
    merchant =
        json['merchant'] != null ? Merchant.fromJson(json['merchant']) : null;
    if (json['specialization'] != null)
      spec = json['specialization'].toString();
    if (json['rates_average'] != null)
      rateAverage = double.parse(json['rates_average'].toString());
    if (json['lastsales'] != null)
      json['lastsales'].forEach((dynamic v) {
        lastsales.add(SaleData.fromJson(v));
      });
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
  int isfavorite;
  int salesCount;
  Merchant merchant;
  String spec;
  double rateAverage;
  List<SaleData> lastsales = <SaleData>[];
}

// class RecentSale {
//   RecentSale(
//       {this.id,
//       this.userId,
//       this.name,
//       this.oldPrice,
//       this.newPrice,
//       this.startAt,
//       this.endAt,
//       this.details,
//       this.merchantId,
//       this.status,
//       this.mainImage,
//       this.createdAt,
//       this.updatedAt,
//       this.pivot});

//   RecentSale.fromJson(dynamic json) {
//     id = json['id'] as int;
//     userId = json['user_id'].toString();
//     name = json['name'].toString();
//     oldPrice = json['old_price'].toString();
//     newPrice = json['new_price'].toString();
//     startAt = json['start_at'].toString();
//     endAt = json['end_at'].toString();
//     details = json['details'].toString();
//     merchantId = json['merchant_id'].toString();
//     status = json['status'].toString();
//     mainImage = json['main_image'].toString();
//     createdAt = json['created_at'].toString();
//     updatedAt = json['updated_at'].toString();
//     pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
//   }
//   int id;
//   String userId;
//   String name;
//   String oldPrice;
//   String newPrice;
//   String startAt;
//   String endAt;
//   String details;
//   String merchantId;
//   String status;
//   String mainImage;
//   String createdAt;
//   String updatedAt;
//   Pivot pivot;
// }

// class Pivot {
//   Pivot({this.branchId, this.saleId});

//   Pivot.fromJson(dynamic json) {
//     branchId = json['branch_id'].toString();
//     saleId = json['sale_id'].toString();
//   }
//   String branchId;
//   String saleId;
// }

class Merchant {
  Merchant({this.id, this.name, this.logo, this.ratesAverage, this.salesCount});

  Merchant.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    logo = json['logo'].toString();
    ratesAverage =double.parse(json['rates_average'].toString());
    salesCount = json['sales_count'] as int;
  }
  int id;
  String name;
  String logo;
  double ratesAverage;
  int salesCount;
}
