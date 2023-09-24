class UserModel {
  bool? success;
  String? message;
  UserData? data;

  UserModel({this.success, this.message, this.data});

  UserModel.fromJson(json) {
    success = json['success'];
    message = json['message'];

    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!;
    }
    return data;
  }
}

class UserData {
  Location? location;
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? profile;
  String? mobile;
  String? password;
  String? gender;
  bool? isVerified;
  String? createdOn;
  String? subscription;

  UserData({this.location, this.sId, this.firstName, this.lastName, this.email, this.profile, this.mobile, this.password, this.gender, this.isVerified, this.createdOn, this.subscription});

  UserData.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profile = json['profile'];
    mobile = json['mobile'];
    password = json['password'];
    gender = json['gender'];
    isVerified = json['isVerified'];
    createdOn = json['createdOn'];
    subscription = json['subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['profile'] = this.profile;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['isVerified'] = this.isVerified;
    data['createdOn'] = this.createdOn;
    data['subscription'] = this.subscription;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
