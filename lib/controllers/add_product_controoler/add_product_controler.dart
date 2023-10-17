// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';

import 'package:bird_x/controllers/location_controller.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/utils/app_image_utils.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/utils/location_utils.dart';
import 'package:bird_x/widgets/app_location_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  TextEditingController price = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  String latitude = "";
  String longitude = "";
  // final ImagePicker _imagePicker = ImagePicker();
  File? thumbnailImage;

  String base64Thumbnail = "";
  List<String> multiImagesbase64 = [];
  List<File> multiImages = [];

  bool isLoading = false;
  final ProductServices _addProductServices = ProductServices();
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

  pickThumbnail({required ImageSource source}) async {
    await ImagePicker.platform.getImageFromSource(source: source).then((value) async {
      if (value != null) {
        var newthumbnail = File(value.path);
        var fileSize = await AppImageUtils.fileSize(newthumbnail);

        if (fileSize > 1) {
          var file = await AppImageUtils.compressImage(
            file: newthumbnail,
            quality: 20,
          );

          thumbnailImage = file;
        } else {
          thumbnailImage = newthumbnail;
        }
        base64Thumbnail = base64Encode(thumbnailImage!.readAsBytesSync());

        update();
      } else {}
    }).catchError((err) {
      if (err is PathAccessException) {
      } else if (err is FileSystemException) {}
    });
  }

  multiimagePicked() async {
    List<File> files = [];
    await FilePicker.platform
        .pickFiles(
      allowMultiple: true,
      type: FileType.image,
    )
        .then((value) {
      if (value != null) {
        for (var i in value.files) {
          files.add(
            File(
              i.path.toString(),
            ),
          );
        }
      }
    });

    if (files.length < 2 || files.length > 5) {
      AppSnackbar.showSnackbar(
        title: "Image Selection Error",
        message: "Please select between 2 to 5 images.",
      );
    } else {
      multiImages.clear();

      for (var element in files) {
        File otherImage = File(element.path);
        var fileSize = await AppImageUtils.fileSize(otherImage);
        if (fileSize > 1) {
          otherImage = await AppImageUtils.compressImage(
            file: otherImage,
            quality: 15,
          );
        }
        multiImages.add(otherImage);
        update();
        String image = base64Encode(otherImage.readAsBytesSync());

        multiImagesbase64.add(image);
      }
    }
    update();
  }

  addProduct(context, {required String categoryName, required String categoryId}) async {
    isLoading = true;
    update();

    if (thumbnailImage == null) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please select your thumbnail picture!");
    } else if (price.text.isEmpty || !price.text.isNotEmpty) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter valid price!");
    } else if (location.text.isEmpty || location.text.toLowerCase().contains("tap again") || location.text.toLowerCase().contains("loading")) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please select your location!");
    } else if (title.text.isEmpty) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter Pet Title!");
    } else if (description.text.isEmpty) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter Description!");
    } else {
      await _addProductServices.addProduct(
        context,
        thumbnail: base64Thumbnail,
        latitude: latitude,
        longitude: longitude,
        price: price.text,
        name: title.text,
        description: description.text,
        multiImages: multiImagesbase64,
        categoryId: categoryId,
        address: location.text,
      );
    }
    isLoading = false;
    update();
  }

  bool isFocused = false;
  changeFocus(bool value) {
    isFocused = value;
    update();
  }
}
