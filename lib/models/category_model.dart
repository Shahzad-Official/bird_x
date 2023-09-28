

class CategoryModel {

  bool? success;
  String? message;
  List<Data>? data;

  CategoryModel({this.success, this.message, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Data {
  String? sId;
  String? categoryName;
  String? categoryIcon;
  String? color;
  String? createdOn;

  Data(
      {this.sId,
      this.categoryName,
      this.categoryIcon,
      this.color,
      this.createdOn});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
    categoryIcon = json['categoryIcon'];
    color = json['color'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['categoryName'] = categoryName;
    data['categoryIcon'] = categoryIcon;
    data['color'] = color;
    data['createdOn'] = createdOn;
    return data;
  }
}
