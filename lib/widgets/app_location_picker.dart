// ignore_for_file: use_build_context_synchronously

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/location_controller.dart';
import 'package:bird_x/services/location_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/location_utils.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppLocationPicker extends StatefulWidget {
  final LatLng? latLng;
  final void Function(LatLng latLng)? onPick;
  const AppLocationPicker({
    Key? key,
    this.latLng,
    this.onPick,
  }) : super(key: key);

  @override
  State<AppLocationPicker> createState() => _AppLocationPickerState();
}

class _AppLocationPickerState extends State<AppLocationPicker> {
  final PlaceApiProvider _placeApiProvider = PlaceApiProvider();

  LatLng latLng = const LatLng(30.1811532, 71.3098456);
  GoogleMapController? _mapController;
  String location = "";
  Set<Marker> marker = {};
  int? mapId;

  getData() async {
    latLng = widget.latLng!;
    marker = {
      Marker(
        markerId: const MarkerId(
          "1",
        ),
        position: latLng,
        onTap: () {
          showCurrentLocation(
            context,
            latLng: latLng,
          );
        },
      ),
    };

    setState(() {});
  }

  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppNavigation.back(context);
        widget.onPick!(latLng);
        return true;
      },
      child: Scaffold(
        body: GetBuilder<LocationController>(
            init: LocationController(),
            builder: (_) {
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: latLng,
                      zoom: 14,
                    ),
                    markers: marker,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    compassEnabled: true,
                    mapToolbarEnabled: false,
                    onCameraMove: (position) {
                      _.closeSearch();
                    },
                    onMapCreated: (controller) {
                      setState(() {
                        _mapController = controller;
                      });
                      showCurrentLocation(
                        context,
                        latLng: latLng,
                      );
                    },
                    onTap: (argument) {
                      _.closeSearch();
                      setState(
                        () {
                          latLng = argument;
                          marker = {
                            Marker(
                              markerId: const MarkerId(
                                "1",
                              ),
                              position: latLng,
                              onTap: () {
                                showCurrentLocation(
                                  context,
                                  latLng: latLng,
                                );
                              },
                            )
                          };
                          _mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                              target: latLng,
                              zoom: 14,
                            )),
                          );
                          showCurrentLocation(
                            context,
                            latLng: latLng,
                          );
                        },
                      );
                    },
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SafeArea(
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                minVerticalPadding: 0,
                                leading: BackButton(
                                  onPressed: () {
                                    AppNavigation.back(context);
                                    widget.onPick!(latLng);
                                  },
                                ),
                                title: Focus(
                                  onFocusChange: (value) {
                                    _.changeFocus(value);
                                  },
                                  child: SearchField(
                                    controller: _.query,
                                    hintText: "Search a Place",
                                    onChanged: (value) async {
                                      await _.fetchSuggestions(value);
                                    },
                                    onSubmit: (value) {
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _.closeSearch();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                              _.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : _.suggestions.isEmpty
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.all(12),
                                          padding: const EdgeInsets.all(10),
                                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Scrollbar(
                                            thumbVisibility: true,
                                            radius: const Radius.circular(5),
                                            thickness: 5,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: _.suggestions.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  contentPadding: const EdgeInsets.only(left: 5),
                                                  onTap: () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    await _placeApiProvider
                                                        .getPlaceDetails(
                                                      _.suggestions[index].placeId.toString(),
                                                    )
                                                        .then(
                                                      (value) {
                                                        _.closeSearch();
                                                        setState(() {
                                                          isLoading = false;
                                                          latLng = value;
                                                        });
                                                        marker = {
                                                          Marker(
                                                            markerId: const MarkerId(
                                                              "1",
                                                            ),
                                                            position: latLng,
                                                            onTap: () {
                                                              showCurrentLocation(
                                                                super.context,
                                                                latLng: latLng,
                                                              );
                                                            },
                                                          ),
                                                        };

                                                        _mapController!.animateCamera(
                                                          CameraUpdate.newCameraPosition(
                                                            CameraPosition(
                                                              target: value,
                                                              zoom: 14,
                                                            ),
                                                          ),
                                                        );
                                                        showCurrentLocation(
                                                          super.context,
                                                          latLng: latLng,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  title: AppText(
                                                    text: _.suggestions[index].description.toString(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                ],
              );
            }),
      ),
    );
  }

  Future<dynamic> showCurrentLocation(
    BuildContext context, {
    required LatLng latLng,
  }) async {
    location = await LocationUtils.translateFullAddress(latitude: latLng.latitude, longitude: latLng.longitude);

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(
                child: AppText(
                  text: "Picked Location",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.heigthSpace20,
              Center(
                child: AppText(
                  text: location,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.heigthSpace20,
              Center(
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primaryColor,
                  heroTag: latLng.toString(),
                  onPressed: () {
                    AppNavigation.back(context);
                    AppNavigation.back(context);
                    widget.onPick!(latLng);
                  },
                  child: const AppText(
                    text: "Ok",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
        // return AppText(text: "text");
      },
    );
  }
}

// class AddressSearch extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         tooltip: 'Clear',
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       tooltip: 'Back',
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return SizedBox.shrink();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return FutureBuilder(
//       future: null,
//       builder: (context, AsyncSnapshot<List<String>> snapshot) => query == ''
//           ? Container(
//               padding: EdgeInsets.all(16.0),
//               child: Text('Enter your address'),
//             )
//           : snapshot.hasData
//               ? ListView.builder(
//                   itemBuilder: (context, index) => ListTile(
//                     title: Text(snapshot.data![index]),
//                     onTap: () {
//                       close(context, snapshot.data![index]);
//                     },
//                   ),
//                   itemCount: snapshot.data?.length,
//                 )
//               : Container(child: Text('Loading...')),
//     );
//   }
// }
