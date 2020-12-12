class LocationImages {
  LocationImages(
      {this.id,
      this.image,
      this.title,
      this.address,
      this.longitude,
      this.latitude,
      this.createdAt,
      this.updatedAt,
      this.imagefull});

  LocationImages.fromJson(dynamic json) {
    id = json['id']as int;
    image = json['image'].toString();
    title = json['title'].toString();
    address = json['address'].toString();
    longitude = json['longitude'].toString();
    latitude = json['latitude'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    imagefull = json['image_full'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_full'] = imagefull;
    return data;
  }
    int id;
  String image;
  String title;
  String address;
  String longitude;
  String latitude;
  String createdAt;
  String updatedAt;
  String imagefull;
}