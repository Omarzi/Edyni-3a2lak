class QuestionModel {
  String? sId;
  String? body;
  List<Options>? options;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? answer;

  QuestionModel(
      {this.sId,
        this.body,
        this.options,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.answer});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    body = json['body'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['body'] = this.body;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['answer'] = this.answer;
    return data;
  }
}

class Options {
  String? option;
  String? sId;

  Options({this.option, this.sId});

  Options.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option'] = this.option;
    data['_id'] = this.sId;
    return data;
  }
}
