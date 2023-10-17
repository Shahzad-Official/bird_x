import 'package:app_settings/app_settings.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/services/location_services.dart';
import 'package:bird_x/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  TextEditingController query = TextEditingController();
  final PlaceApiProvider _placeApiProvider = PlaceApiProvider();
  List<Suggestion> suggestions = [];

  bool isLoading = false;

  fetchSuggestions(String query) async {
    isLoading = true;
    update();
    suggestions = await _placeApiProvider.getPlaceAutocomplete(query);
    isLoading = false;
    update();
  }

  closeSearch() {
    suggestions = [];
    query.text = "";
    update();
    changeFocus(false);
  }

  bool isFocus = false;
  changeFocus(bool value) {
    isFocus = value;
    update();
  }

  LocationData? currentPosition;

  String currentAddress = "";

  Location location = Location();

  pickCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        currentAddress = "Tap Again";
        return;
      } else {
        await currentPositionGet();
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.deniedForever) {
        Get.defaultDialog(
          title: "Please enable location permission from app settings",
          content: const SizedBox(),
          onConfirm: () async {
            Get.back();
            await AppSettings.openAppSettings().then((value) async {
              await currentPositionGet(
                isDenied: true,
              );
            }).catchError((err) {
              debugPrint("settings error $err");
            });
          },
          onCancel: () {
            Get.back();
          },
        );
      } else if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await currentPositionGet();
  }

  currentPositionGet({bool isDenied = false}) async {
    currentAddress = "Loading....";
    update();
    await location.getLocation().then((value) async {
      currentPosition = value;

      currentAddress = await LocationUtils.translateAddress(latitude: value.latitude!, longitude: value.longitude!);
      box.put("myAddress", currentAddress);
      update();
    }).catchError((err) {
      currentAddress = "Tap Again";
      update();
    });
  }
}
