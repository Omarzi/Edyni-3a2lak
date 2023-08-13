class LevelModel {
  int? minPoints;
  String? sId;
  int? number;
  List<String>? question;
  String? image;
  String? gift;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LevelModel(
      {this.minPoints,
        this.sId,
        this.number,
        this.question,
        this.image,
        this.gift,
        this.createdAt,
        this.updatedAt,
        this.iV});

  LevelModel.fromJson(Map<String, dynamic> json) {
    minPoints = json['min_points'];
    sId = json['_id'];
    number = json['number'];
    question = json['question'].cast<String>();
    image = json['image'];
    gift = json['gift'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_points'] = this.minPoints;
    data['_id'] = this.sId;
    data['number'] = this.number;
    data['question'] = this.question;
    data['image'] = this.image;
    data['gift'] = this.gift;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
