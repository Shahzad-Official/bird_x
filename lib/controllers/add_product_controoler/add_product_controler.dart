import 'dart:convert';
import 'dart:io';

import 'package:bird_x/services/location_services.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/utils/app_image_utils.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  TextEditingController price = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  String latitude = "";
  String longitude = "";
  final ImagePicker _imagePicker = ImagePicker();
  File? thumbnailImage;

  String base64Thumbnail = "";
  List<String> multiImagesbase64 = [];
  List<File> multiImages = [];

  bool isLoading = false;
  final ProductServices _addProductServices = ProductServices();
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

  pickThumbnail({required ImageSource source}) async {
    await _imagePicker.pickImage(source: source).then((value) async {
      if (value != null) {
        var newthumbnail = File(value.path);
        var fileSize = await AppImageUtils.fileSize(newthumbnail);
        if (fileSize > 2) {
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
    final List<XFile> pickedImage = await _imagePicker.pickMultiImage();

    if (pickedImage.length < 2 || pickedImage.length > 5) {
      AppSnackbar.showSnackbar(
        title: "Image Selection Error",
        message: "Please select between 2 to 5 images.",
      );
    } else {
      multiImages.clear();

      for (var element in pickedImage) {
        File otherImage = File(element.path);
        var fileSize = await AppImageUtils.fileSize(otherImage);
        if (fileSize > 2) {
          otherImage = await AppImageUtils.compressImage(
            file: otherImage,
            quality: 10,
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
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter valid email price!");
    } else if (title.text.isEmpty) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter title!");
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
      isLoading = false;
      update();
    }
  }

  bool isFocused = false;
  changeFocus(bool value) {
    isFocused = value;
    update();
  }
}
