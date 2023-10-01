import 'package:bird_x/models/user_model.dart';

class AllProductsModel {
  bool? success;
  String? message;
  List<ProductData>? productData;
  int? perPage;
  int? totalPages;
  int? totalDocs;
  int? currentPage;

  AllProductsModel({this.success, this.message, this.productData, this.perPage, this.totalPages, this.totalDocs, this.currentPage});

  AllProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      productData = <ProductData>[];
      json['data'].forEach((v) {
        productData!.add(ProductData.fromJson(v));
      });
    }
    perPage = json['perPage'];
    totalPages = json['totalPages'];
    totalDocs = json['totalDocs'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (productData != null) {
      data['data'] = productData!.map((v) => v.toJson()).toList();
    }
    data['perPage'] = perPage;
    data['totalPages'] = totalPages;
    data['totalDocs'] = totalDocs;
    data['currentPage'] = currentPage;
    return data;
  }
}

class ProductData {
  String? sId;
  String? name;
  String? country;
  String? userId;
  String? categoryId;
  String? description;
  String? price;
  Location? location;
  String? thumbnail;
  List<String>? otherPics;
  String? startDate;
  String? endDate;
  UserData? user;
  Category? category;

  ProductData(
      {this.sId,
      this.name,
      this.country,
      this.userId,
      this.categoryId,
      this.description,
      this.price,
      this.location,
      this.thumbnail,
      this.otherPics,
      this.startDate,
      this.endDate,
      this.user,
      this.category});

  ProductData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    country = json['country'];
    userId = json['userId'];
    categoryId = json['categoryId'];
    description = json['description'];
    price = json['price'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    thumbnail = json['thumbnail'];
    otherPics = json['otherPics'].cast<String>();
    startDate = json['startDate'];
    endDate = json['endDate'];
    user = json['User'] != null ? UserData.fromJson(json['User']) : null;
    category = json['Category'] != null ? Category.fromJson(json['Category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['country'] = country;
    data['userId'] = userId;
    data['categoryId'] = categoryId;
    data['description'] = description;
    data['price'] = price;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['thumbnail'] = thumbnail;
    data['otherPics'] = otherPics;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (category != null) {
      data['Category'] = category!.toJson();
    }
    return data;
  }
}

class Location {
  String? address;
  String? latitude;
  String? longitude;

  Location({this.address, this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Category {
  String? sId;
  String? categoryName;
  String? categoryIcon;
  String? color;
  String? createdOn;

  Category({this.sId, this.categoryName, this.categoryIcon, this.color, this.createdOn});

  Category.fromJson(Map<String, dynamic> json) {
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
