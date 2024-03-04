import 'dart:convert';

import 'package:flutter_weather_app/utils/api_url.dart';
import 'package:http/http.dart' as http;

import '../models/Search/search.dart';

class FetcherPlaceApi {
  Future<List<SearchInfo>> getPlaces(String place) async {
    var response = await http.get(searchApiURL(place));
    var jsonString = jsonDecode(response.body);

    return (jsonString['features'] as List)
        .map((e) => SearchInfo.fromJson(e))
        .toList();
  }
}
