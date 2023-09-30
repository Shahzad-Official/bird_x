class LoginModel {
  bool? success;
  String? message;
  UserData? data;
  String? token;

  LoginModel({this.success, this.message, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
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
  String? subscription;
  bool? isOnline;
  String? referralCode;
  String? createdOn;
  String? lastActive;

  UserData(
      {this.location,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.profile,
      this.mobile,
      this.password,
      this.gender,
      this.isVerified,
      this.subscription,
      this.isOnline,
      this.referralCode,
      this.createdOn,
      this.lastActive});

  UserData.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profile = json['profile'];
    mobile = json['mobile'];
    password = json['password'];
    gender = json['gender'];
    isVerified = json['isVerified'];
    subscription = json['subscription'];
    isOnline = json['isOnline'];
    referralCode = json['referralCode'];
    createdOn = json['createdOn'];
    lastActive = json['lastActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['profile'] = profile;
    data['mobile'] = mobile;
    data['password'] = password;
    data['gender'] = gender;
    data['isVerified'] = isVerified;
    data['subscription'] = subscription;
    data['isOnline'] = isOnline;
    data['referralCode'] = referralCode;
    data['createdOn'] = createdOn;
    data['lastActive'] = lastActive;
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
