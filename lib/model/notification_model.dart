class NotificationModel {
  String? sId;
  String? title;
  String? body;
  String? expireAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotificationModel(
      {this.sId,
        this.title,
        this.body,
        this.expireAt,
        this.createdAt,
        this.updatedAt,
        this.iV});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    body = json['body'];
    expireAt = json['expireAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['expireAt'] = this.expireAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
