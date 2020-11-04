import 'package:joker/constants/config.dart';

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
      this.apiToken,
      this.birthDate});

  Profile.fromJson(dynamic json) {
    id = json['data']['id'] as int;
    name = json['data']['name'].toString();
    username = json['data']['username'].toString();
    email = json['data']['email'].toString();
    emailVerifiedAt = json['data']['email_verified_at'].toString();
    countryId = json['data']['country_id'].toString();
    cityId = json['data']['city_id'].toString();
    if (json['data']['address'] != null)
      address = json['data']['address'].toString();
    longitude = json['data']['longitude'].toString();
    latitude = json['data']['latitude'].toString();
    phone = json['data']['phone'].toString();
    status = json['data']['status'].toString();
    userType = json['data']['user_type'].toString();
    image = json['data']['image'].toString();
    verfiyCode = json['data']['verfiy_code'].toString();
    createdAt = json['data']['created_at'].toString();
    updatedAt = json['data']['updated_at'].toString();
    apiToken = json['data']['api_token'].toString();
    birthDate = json['data']['birth_date'].toString();
  }
  int id;
  String name;
  String username;
  String email;
  String emailVerifiedAt;
  String countryId;
  String cityId;
  String address= config.locationController.text;
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
  String birthDate;
}
