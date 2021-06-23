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
      this.address,
      this.phone,
      this.latitude,
      this.longitude,
      this.ratesCount,
      this.ratesAverage,
      this.likesCount,
      this.isliked,
      this.isfavorite,
      this.sales,
      this.lastsales,
      this.merchant,
      this.specialization});

  BranchData.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'] as String;
    address = json['address'] as String;
    phone = json['phone'] as String;
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
    ratesCount = json['rates_count'] as int;
    ratesAverage = double.parse(json['rates_average'].toString());
    likesCount = json['likes_count'] as int;
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
    sales = json['sales'] as int;
    if (json['lastsales'] != null) {
      lastsales = <Lastsales>[];
      json['lastsales'].forEach((dynamic v) {
        lastsales.add(Lastsales.fromJson(v));
      });
    }
    merchant = MerchantfromBranch.fromJson(json['merchant']);
    specialization = json['specialization'].toString();
  }
  int id;
  String name;
  String address;
  String phone;
  double latitude;
  double longitude;
  int ratesCount;
  double ratesAverage=0;
  int likesCount;
  int isliked;
  int isfavorite;
  int sales;
  List<Lastsales> lastsales;
  String specialization;
  MerchantfromBranch merchant;
}

class MerchantfromBranch {
  MerchantfromBranch(
      {this.id, this.name, this.logo, this.rateAverage, this.salesCount});
  MerchantfromBranch.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    logo = json['logo'] as String;
    rateAverage = double.parse(json['rates_average'].toString());
    salesCount = json['sales_count'] as int;
  }
  int id;
  String name;
  String logo;
  double rateAverage;
  int salesCount;
}

class Lastsales {
  Lastsales(
      {this.id,
      this.name,
      this.oldPrice,
      this.price,
      this.discount,
      this.startAt,
      this.period,
      this.startPeriod,
      this.endAt,
      this.details,
      this.status,
      this.branches,
      this.mainImage,
      this.cropedImage,
      this.images,
      this.isliked,
      this.isfavorite,
      this.merchant});

  Lastsales.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    oldPrice = double.parse(json['old_price'].toString());
    price = double.parse(json['new_price'].toString());
    discount = json['discount'].toString();
    startAt = json['start_at'].toString();
    period = json['period'].toString();
    if(json['start_period']!=null){
       json['start_period'].forEach((dynamic v) {
        startPeriod.add(int.parse(v.toString()));
      });
    }
    // startPeriod = json['start_period'] as List<int>;
    endAt = json['end_at'].toString();
    details = json['details'].toString();
    status = json['status'].toString();
    if (json['branches'] != null) {
      branches = <BranchesLastSales>[];
      json['branches'].forEach((dynamic v) {
        branches.add(BranchesLastSales.fromJson(v));
      });
    }
    mainImage = json['main_image'].toString();
    cropedImage = json['croped_image'].toString();
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((dynamic v) {
        images.add(Images.fromJson(v));
      });
    }
    isliked = json['isliked'] as int;
    isfavorite = json['isfavorite'] as int;
    merchant = json['merchant'] != null
        ? MerchantfromBranch.fromJson(json['merchant'])
        : null;
  }

  int id;
  String name;
  double oldPrice;
  double price;
  String discount;
  String startAt;
  String period;
  List<int> startPeriod=<int>[];
  String endAt;
  String details;
  String status;
  List<BranchesLastSales> branches;
  String mainImage;
  String cropedImage;
  List<Images> images;
  int isliked;
  int isfavorite;
  MerchantfromBranch merchant;
}

class BranchesLastSales {
  BranchesLastSales({this.id, this.name, this.longitude, this.latitude});

  BranchesLastSales.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    longitude = double.parse(json['longitude'].toString());
    latitude = double.parse(json['latitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }

  int id;
  String name;
  double longitude;
  double latitude;
}

class Images {
  Images({this.imageTitle, this.details});

  Images.fromJson(dynamic json) {
    imageTitle = json['image_title'].toString();
    details = json['details'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_title'] = imageTitle;
    data['details'] = details;
    return data;
  }

  String imageTitle;
  String details;
}
