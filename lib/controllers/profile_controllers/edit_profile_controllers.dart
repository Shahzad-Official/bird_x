import 'dart:convert';
import 'dart:io';
import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/location_services.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_image_utils.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  String countryCode = "";

  String latitude = "";
  String longitude = "";
  String groupValue = "Male";
  changeGender(String value) {
    groupValue = value;
    update();
  }

  bool isObsecure = true;
  changeObsecurity() {
    isObsecure = !isObsecure;
    update();
  }

  bool isObsecureOld = true;
  changeObsecurityOld() {
    isObsecureOld = !isObsecureOld;
    update();
  }

  bool isObsecure1 = true;
  changeObsecurity1() {
    isObsecure1 = !isObsecure1;
    update();
  }

  bool isLoading = false;

  File? profile;
  String base64Image = "";
  pickProfile({required ImageSource source}) async {
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.getImageFromSource(source: source).then((value) async {
      if (value != null) {
        var newprofile = File(value.path);
        var fileSize = await AppImageUtils.fileSize(newprofile);
        if (fileSize > 2) {
          var file = await AppImageUtils.compressImage(
            file: newprofile,
            quality: fileSize > 5 && fileSize <= 10
                ? 20
                : fileSize > 10
                    ? 30
                    : 50,
          );

          profile = file;
        } else {
          profile = newprofile;
        }
        base64Image = base64Encode(profile!.readAsBytesSync());

        update();
      } else {}
    }).catchError((err) {
      if (err is PathAccessException) {
      } else if (err is FileSystemException) {}
    });
  }

  pickLocation(context) async {
    location.text = "loading....";
    var isenable = await LocationServices().determinePosition();
    if (!isenable) {
      Get.defaultDialog(
        title: "Please enable location permissions",
        content: const SizedBox(),
        onConfirm: () async {
          await Geolocator.openLocationSettings().then((value) async {
            location.text = "Tap again";
            Get.back();
          });
        },
        onCancel: () {
          Get.back();
        },
      );
    } else {
      await AppNavigation.to(
        context,
        nextPage: PlacePicker(
          apiKey: "AIzaSyDq33g2UnBUqsMbCPvHT8imFd20IsLuel0",
          initialPosition: const LatLng(30.1811532, 71.3098456),
          enableMyLocationButton: true,
          useCurrentLocation: true,
          onPlacePicked: (value) async {
            latitude = value.geometry!.location.lat.toString();
            longitude = value.geometry!.location.lng.toString();
            AppNavigation.back(context);
            location.text = await LocationServices.translateAddress(latitude: value.geometry!.location.lat, longitude: value.geometry!.location.lng);
          },
        ),
      );
    }
    location.text = "Tap again";
  }

  initializeData(LoginModel loginModel) async {
    UserData userData = loginModel.data == null ? UserData() : loginModel.data!;
    print("profile is => ${userData.profile}");
    if (userData.profile!.trim().isNotEmpty) {
      DefaultCacheManager manager = DefaultCacheManager();
      var file = await manager.downloadFile("${ApiConstant.baseUrl}/${userData.profile}");
      profile = file.file;
      update();
    }
    firstName.text = userData.firstName.toString();
    lastName.text = userData.lastName.toString();
    email.text = userData.email.toString();
    number.text = userData.mobile.toString();
    groupValue = userData.gender.toString();
    location.text = userData.location!.address.toString();
  }

  editUser(context, {bool isUpdatePage = true}) async {
    isLoading = true;
    update();
    if (isUpdatePage) {
      await RegistrationServices().updateProfile(
        context,
        firstName: firstName.text,
        lastName: lastName.text,
        address: location.text,
        longitude: longitude,
        latitude: latitude,
        gender: groupValue,
        mobile: number.text,
        mobileCode: countryCode,
        profile: base64Image,
      );
    } else {
      await RegistrationServices().updateProfile(
        context,
        address: location.text,
        longitude: longitude,
        latitude: latitude,
        gender: groupValue,
        mobile: number.text,
        mobileCode: countryCode,
      );
    }
    isLoading = false;
    update();
  }

  updatePassword(
    context, {
    required String email,
  }) async {
    isLoading = true;
    update();
    if (password.text.isEmpty || password.text.length < 6) {
      AppSnackbar.showSnackbar(title: "Error", message: "Password must be 6 character!");
    } else if (password.text != cpassword.text) {
      AppSnackbar.showSnackbar(title: "Error", message: "Check your confirm password!");
    } else {
      await RegistrationServices().updatePassword(
        context,
        email: email,
        password: password.text,
        oldPassword: oldPassword.text,
      );
    }

    isLoading = false;
    update();
  }
}
