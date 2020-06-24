class User {
  User(
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
      this.birthDate,
      this.createdAt,
      this.updatedAt,
      this.apiToken});

  User.fromJson(dynamic json) {
    id = json['id']as int;
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
    birthDate = json['birth_date'].toString();
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
  String birthDate;
  String createdAt;
  String updatedAt;
  String apiToken;
}