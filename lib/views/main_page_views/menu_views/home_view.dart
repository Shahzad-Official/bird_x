import 'package:bird_x/services/location_services.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? currentLocation;
  final LocationServices _locationServices = LocationServices();
  bool isLoading = false;
  initializeLocation() async {
    setState(() {
      isLoading = true;
    });
    Position? position;

    position = await _locationServices.determinePosition().then((value) async {
      List<Placemark> placemark = await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark newPlace = placemark[0];
      if (mounted) {
        setState(() {
          currentLocation = "${newPlace.subAdministrativeArea!} , ${newPlace.administrativeArea!} , ${newPlace.country!}";
          isLoading = false;
        });
      }
      return value;
    }).catchError((err) {
      if (mounted) {
        setState(() {
          currentLocation = null;
          isLoading = false;
        });
      }
      return position!;
    });
  }

  @override
  void initState() {
    initializeLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 9,
                  child: TextButton(
                    onPressed: currentLocation == null
                        ? () async {
                            await initializeLocation();
                          }
                        : null,
                    child: AppText(
                      overFlow: TextOverflow.ellipsis,
                      text: isLoading
                          ? "loading... "
                          : currentLocation == null
                              ? "Pick Your Location 📍"
                              : currentLocation!,
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {},
                    child: AppShadowcontainer(
                      child: SvgPicture.asset(
                        "assets/icons/bell.svg",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
