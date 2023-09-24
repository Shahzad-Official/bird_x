import 'dart:convert';
import 'dart:io';
import 'package:bird_x/utils/app_image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  String countryCode = "";

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
    await ImagePicker.platform
        .getImageFromSource(source: source)
        .then((value) async {
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

  editUser(context) async {
    isLoading = true;
    update();

    isLoading = false;
    update();
  }
}
