import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  String apiKey = "AIzaSyDq33g2UnBUqsMbCPvHT8imFd20IsLuel0";
  Future<List<Suggestion>> getPlaceAutocomplete(
    String input,
  ) async {
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Suggestion> suggestions = [];
      for (var i in data['predictions']) {
        suggestions.add(Suggestion(i['place_id'], i['description']));
      }
      return suggestions;
    } else {
      throw Exception('Failed to load place predictions');
    }
  }

  Future<LatLng> getPlaceDetails(String placeId) async {
    LatLng latLng;
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      Map<String, dynamic> result = data['result']['geometry']['location'];
      latLng = LatLng(
        result['lat'],
        result['lng'],
      );

      return latLng;
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
