class CategoryModel {
  String? sId;
  String? category;
  List<String>? level;
  String? createdAt;
  String? updatedAt;
  String? image;
  int? iV;

  CategoryModel(
      {this.sId,
        this.category,
        this.level,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.iV});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
    level = json['level'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    image = json['image'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category'] = this.category;
    data['level'] = this.level;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['image']=image;
    data['__v'] = this.iV;
    return data;
  }
}
