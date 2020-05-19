class Profile {


  Profile(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.emailVerifiedAt,
      this.countryId,
      this.cityId,
      this.address,
      this.longitude,
      this.latitude,
      this.phone,
      this.status,
      this.userType,
      this.image,
      this.verfiyCode,
      this.createdAt,
      this.updatedAt,
      this.apiToken});

  Profile.fromJson( dynamic json) {
    id = json['id'] as int;
    name = json['name'].toString();
    username = json['username'].toString();
    email = json['email'].toString();
    emailVerifiedAt = json['email_verified_at'].toString();
    countryId = json['country_id'].toString();
    cityId = json['city_id'].toString();
    address = json['address'].toString();
    longitude = json['longitude'].toString();
    latitude = json['latitude'].toString();
    phone = json['phone'].toString();
    status = json['status'].toString();
    userType = json['user_type'].toString();
    image = json['image'].toString();
    verfiyCode = json['verfiy_code'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    apiToken = json['api_token'].toString();
  }
  int id;
  String name;
  String username;
  String email;
  String emailVerifiedAt;
  String countryId;
  String cityId;
  String address;
  String longitude;
  String latitude;
  String phone;
  String status;
  String userType;
  String image;
  String verfiyCode;
  String createdAt;
  String updatedAt;
  String apiToken;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['country_id'] = countryId;
    data['city_id'] = cityId;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['phone'] = phone;
    data['status'] = status;
    data['user_type'] = userType;
    data['image'] = image;
    data['verfiy_code'] = verfiyCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['api_token'] = apiToken;
    return data;
  }
}
