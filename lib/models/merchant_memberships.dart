class MerchantMemberShip {
  MerchantMemberShip({this.data});

  MerchantMemberShip.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <MemFromMerchant>[];
      json['data'].forEach((dynamic v) {
        data.add(MemFromMerchant.fromJson(v));
      });
    }
  }
  List<MemFromMerchant> data;
}

class MemFromMerchant {
  MemFromMerchant(
      {this.id,
      this.title,
      this.gender,
      this.ageStage,
      this.message,
      this.type,
      this.status,
      this.createdAt,
      this.merchant});

  MemFromMerchant.fromJson(dynamic json) {
    id = json['id'] as int;
    title = json['title'].toString();
    gender = json['gender'].toString();
    ageStage = json['age_stage'].toString();
    message = json['message'].toString();
    type = json['type'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    merchant = json['merchant'].toString();
  }
  int id;
  String title;
  String gender;
  String ageStage;
  String message;
  String type;
  String status;
  String createdAt;
  String merchant;
}
