class UserModel {
  String? sId;
  String? name;
  String? phone;
  String? password;
  String? referralCode;
  String? email;
  String? image;
  int? points;
  int? gold;
  int? quizzesPlayed;
  int? level;
  bool? active;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserModel(
      {this.sId,
        this.name,
        this.phone,
        this.password,
        this.referralCode,
        this.email,
        this.image,
        this.points,
        this.gold,
        this.quizzesPlayed,
        this.level,
        this.active,
        this.createdAt,
        this.updatedAt,
        this.iV});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    referralCode = json['referral_code'];
    email = json['email'];
    image = json['image'];
    points = json['points'];
    gold = json['gold'];
    quizzesPlayed = json['quizzes_played'];
    level = json['level'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['referral_code'] = this.referralCode;
    data['email'] = this.email;
    data['image'] = this.image;
    data['points'] = this.points;
    data['gold'] = this.gold;
    data['quizzes_played'] = this.quizzesPlayed;
    data['level'] = this.level;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
