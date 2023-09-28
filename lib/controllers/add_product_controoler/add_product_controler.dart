import 'dart:convert';
import 'dart:io';

import 'package:bird_x/services/add_product_services.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  TextEditingController price = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();

  File? thumnail;
  String base64Image = "";
  List<File?> multiImages = [];
  bool isLoading = false;
  final AddProductServices _addProductServices = AddProductServices();

  pickProfile({required ImageSource source}) async {
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.getImageFromSource(source: source).then((value) {
      if (value != null) {
        thumnail = File(value.path);
        base64Image = base64Encode(thumnail!.readAsBytesSync());
        debugPrint(base64Image);
        update();
      } else {}
    }).catchError((err) {
      if (err is PathAccessException) {
      } else if (err is FileSystemException) {}
    });
  }

  final ImagePicker _imagePicker = ImagePicker();

  multiimagePicked() async {
    final List<XFile> pickedImage = await _imagePicker.pickMultiImage();

    if (pickedImage.length < 2 || pickedImage.length > 5) {
      AppSnackbar.showSnackbar(
        title: "Image Selection Error",
        message: "Please select between 2 to 5 images.",
      );
    } else {
      multiImages.clear();

      for (var element in pickedImage) {
        multiImages.add(File(element.path));
      }
    }
    update();
  }

  addProduct(context) async {
    isLoading = true;
    update();
    if (thumnail == null) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please select your thumbnail picture!");
    } else if (price.text.isEmpty || !price.text.isNotEmpty) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please enter valid email price!");
    } else if (title.text.isEmpty) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter title!");
    } else if (description.text.isEmpty) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please enter Description!");
    } else {
      await _addProductServices.addProduct(
        context,
        profile: base64Image,
        latitude: "latitude",
        longitude: "longitude",
        price: price.text,
        name: title.text,
        description: description.text,
        multiImages: multiImages,
      );
    }
    isLoading = false;
    update();
  }
}
