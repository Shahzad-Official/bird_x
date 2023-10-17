import 'dart:convert';
import 'dart:io';
import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/controllers/location_controller.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_image_utils.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/utils/location_utils.dart';
import 'package:bird_x/widgets/app_location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  final LocationController _locationController = Get.put(LocationController());

  pickLocation(context) async {
    location.text = "loading....";
    await _locationController.pickCurrentLocation();
    if (_locationController.currentPosition == null) {
      location.text = "Tap Again";
    } else {
      LatLng latLng;
      latLng = _locationController.currentPosition == null ? const LatLng(0, 0) : LatLng(_locationController.currentPosition!.latitude!, _locationController.currentPosition!.longitude!);
      await AppNavigation.to(
        context,
        nextPage: AppLocationPicker(
          latLng: latLng,
          onPick: (latLng) async {
            location.text = await LocationUtils.translateAddress(latitude: latLng.latitude, longitude: latLng.longitude);
            latitude = latLng.latitude.toString();
            longitude = latLng.longitude.toString();
          },
        ),
      );
    }
  }

  initializeData(LoginModel loginModel) async {
    UserData userData = loginModel.data == null ? UserData() : loginModel.data!;

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
    countryCode = userData.mobileCode.toString();
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
      if (number.text.isEmpty) {
        AppSnackbar.showSnackbar(title: "Error", message: "Please enter your valid mobile number!");
      } else if (location.text.isEmpty || location.text.toLowerCase().contains("loading") || location.text.toLowerCase().contains("tap again")) {
        AppSnackbar.showSnackbar(title: "Error", message: "Please select your valid location!");
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
