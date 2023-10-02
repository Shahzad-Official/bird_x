class LoginModel {
  bool? success;
  String? message;
  UserData? data;
  Country? country;
  String? token;

  LoginModel({this.success, this.message, this.data, this.country, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
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
  String? mobileCode;
  String? password;
  String? gender;
  bool? isVerified;
  String? subscription;
  bool? isOnline;
  String? referralCode;
  String? referrerCode;
  String? createdOn;
  String? lastActive;
  String? fcmToken;

  UserData(
      {this.location,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.profile,
      this.mobile,
      this.mobileCode,
      this.password,
      this.gender,
      this.isVerified,
      this.subscription,
      this.isOnline,
      this.referralCode,
      this.referrerCode,
      this.createdOn,
      this.lastActive,
      this.fcmToken});

  UserData.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profile = json['profile'];
    mobile = json['mobile'];
    mobileCode = json['mobileCode'];
    password = json['password'];
    gender = json['gender'];
    isVerified = json['isVerified'];
    subscription = json['subscription'];
    isOnline = json['isOnline'];
    referralCode = json['referralCode'];
    referrerCode = json['referrerCode'];
    createdOn = json['createdOn'];
    lastActive = json['lastActive'];
    fcmToken = json['fcmToken'];
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
    data['mobileCode'] = mobileCode;
    data['password'] = password;
    data['gender'] = gender;
    data['isVerified'] = isVerified;
    data['subscription'] = subscription;
    data['isOnline'] = isOnline;
    data['referralCode'] = referralCode;
    data['referrerCode'] = referrerCode;
    data['createdOn'] = createdOn;
    data['lastActive'] = lastActive;
    data['fcmToken'] = fcmToken;
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

class Country {
  String? sId;
  String? countryName;
  String? countryIso;
  String? currencyName;
  String? currencyCode;
  String? currencySymbol;

  Country({this.sId, this.countryName, this.countryIso, this.currencyName, this.currencyCode, this.currencySymbol});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    countryName = json['countryName'];
    countryIso = json['countryIso'];
    currencyName = json['currencyName'];
    currencyCode = json['currencyCode'];
    currencySymbol = json['currencySymbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['countryName'] = countryName;
    data['countryIso'] = countryIso;
    data['currencyName'] = currencyName;
    data['currencyCode'] = currencyCode;
    data['currencySymbol'] = currencySymbol;
    return data;
  }
}
