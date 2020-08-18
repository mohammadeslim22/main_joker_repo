class Memberships {
  Memberships({this.data, this.links, this.meta});

  Memberships.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <MembershipData>[];
      json['data'].forEach((dynamic v) {
        data.add(MembershipData.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<MembershipData> data;
  Links links;
  Meta meta;
}

class MembershipData {
  MembershipData(
      {this.id,
      this.status,
      this.startAt,
      this.endAt,
      this.qrCode,
      this.createdAt,
      this.membership});

  MembershipData.fromJson(dynamic json) {
    id = json['id'] as int;
    status = json['status'].toString();
    startAt = json['start_at'].toString();
    endAt = json['end_at'].toString();
    qrCode = json['qr_code'].toString();
    createdAt = json['created_at'].toString();
    membership = json['membership'] != null
        ? Membership.fromJson(json['membership'])
        : null;
  }
  int id;
  String status;
  String startAt;
  String endAt;
  String qrCode;
  String createdAt;
  Membership membership;
}

class Membership {
  Membership(
      {this.id,
      this.title,
      this.gender,
      this.ageStage,
      this.meesage,
      this.type,
      this.status,
      this.createdAt,
      this.merchantId,
      this.merchant});

  Membership.fromJson(dynamic json) {
    id = json['id'] as int;
    title = json['title'].toString();
    gender = json['gender'].toString();
    ageStage = json['age_stage'].toString();
    meesage = json['meesage'].toString();
    type = json['type'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    merchant = json['merchant'].toString();
    merchantId = json['merchant_id'] as int;
  }
  int id;
  String title;
  String gender;
  String ageStage;
  String meesage;
  String type;
  String status;
  String createdAt;
  int merchantId;
  String merchant;
}

class Links {
  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(dynamic json) {
    first = json['first'].toString();
    last = json['last'].toString();
    prev = json['prev'].toString();
    next = json['next'].toString();
  }
  String first;
  String last;
  String prev;
  String next;
}

class Meta {
  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(dynamic json) {
    currentPage = json['current_page'] as int;
    from = json['from'] as int;
    lastPage = json['last_page'] as int;
    path = json['path'].toString();
    perPage = json['per_page'] as int;
    to = json['to'] as int;
    total = json['total'] as int;
  }
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;
}
