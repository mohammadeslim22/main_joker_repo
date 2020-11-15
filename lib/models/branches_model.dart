class Branches {
  Branches({this.data});

  Branches.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <BranchData>[];
      json['data'].forEach((dynamic v) {
        data.add(BranchData.fromJson(v));
      });
    }
  }
  List<BranchData> data;
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
    latitude = double.parse(json['latitude'].toString());

    longitude = double.parse(json['longitude'].toString());
    address = json['address'] as String;
    phone = json['phone'] as String;
     salesCount = json['sales'] as int;
    merchant = MerchantfromBranch.fromJson(json['merchant']);
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
    print("is favorite $id $isfavorite");
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
    rateAverage = double.parse(json['rates_average'].toString());
  }
  int id;
  String name;
  String logo;
  double rateAverage;
}
