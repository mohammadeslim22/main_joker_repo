class Merchant {
  const Merchant(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});
  final int currentPage;
  final List<Data> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String prevPageUrl;
  final int to;
  final int total;

  static Merchant fromJson(dynamic json) {
    print(json['data']);
    return Merchant(
      currentPage: json['current_page'] as int,
      data: json['data'] != null
          ? Data.fromJson(json['data'] as List<dynamic>) 
          : null,
      firstPageUrl: json['firstPageUrl'] as String,
      from: json['from'] as int,
      lastPage: json['lastPage'] as int,
      lastPageUrl: json['lastPageUrl'] as String,
      nextPageUrl: json['nextPageUrl'] as String,
      path: json['path'] as String,
      perPage: json['perPage'] as int,
      prevPageUrl: json['prevPageUrl'] as String,
      to: json['to'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['cat_note'] = id;
    // data['cat_todo'] = title;
    // data['cat_rem'] = image;
    // data['cat_tag'] = display;
    // data['cat_urgent'] = startingDate;
    // data['cat_work'] = endDtae;
    // data['cat_office'] = desc;

    return data;
  }
}

class Data {
  const Data(
      {this.id,
      this.name,
      this.managerID,
      this.status,
      this.datastatus,
      this.complete,
      this.logo,
      this.creatorId,
      this.updatorId,
      this.createdAt,
      this.updatedAt,
      this.branches});
  final int id;
  final String name;
  final String managerID;
  final String status;
  final String datastatus;
  final String complete;
  final String logo;
  final String creatorId;
  final String updatorId;
  final String createdAt;
  final String updatedAt;
  final List<Branch> branches;
  static List<Data> fromJson(List<dynamic> json) {
    return json.map((dynamic merchant) {
      return Data(
        id: merchant['id'] as int,
        name: merchant['name'] as String,
        managerID: merchant['managerID'] as String,
        status: merchant['status'] as String,
        datastatus: merchant['datastatus'] as String,
        complete: merchant['complete'] as String,
        logo: merchant['logo'] as String,
        creatorId: merchant['creatorId'] as String,
        updatorId: merchant['updatorId'] as String,
        createdAt: merchant['createdAt'] as String,
        updatedAt: merchant['updatedAt'] as String,
        branches: merchant['branches'] != null
            ? Branch.fromJson(merchant['branches']as List<dynamic>) 
            : null,
      );
    }).toList();
  }
}

class Branch {
  const Branch({
    this.id,
    this.merchantId,
    this.userId,
    this.name,
    this.country,
    this.city,
    this.logo,
    this.website,
    this.phone,
    this.address,
    this.langitude,
    this.latitude,
    this.status,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
  });
  final int id;
  final int merchantId;
  final int userId;
  final String name;
  final String country;
  final String city;
  final String logo;
  final String website;
  final String phone;
  final String address;
  final String langitude;
  final String latitude;
  final String status;
  final String apiToken;
  final String createdAt;
  final String updatedAt;
  static List<Branch> fromJson(List<dynamic> json) {
    return json.map((dynamic branch) {
    return Branch(
      id: branch['id'] as int,
      merchantId: branch['merchantId'] as int,
      userId: branch['userId'] as int,
      name: branch['name'] as String,
      country: branch['country'] as String,
      city: branch['city'] as String,
      logo: branch['logo'] as String,
      website: branch['website'] as String,
      phone: branch['phone'] as String,
      address: branch['address'] as String,
      langitude: branch['langitude'] as String,
      status: branch['status'] as String,
      apiToken: branch['apiToken'] as String,
      createdAt: branch['createdAt'] as String,
      updatedAt: branch['updatedAt'] as String,
    );
      }).toList();
  }
}
