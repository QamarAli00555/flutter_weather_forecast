import 'package:flutter/material.dart';
import 'package:flutter_weather_app/services/fetch_location.dart';

import '../models/Search/search.dart';

class SearchNotifier extends ChangeNotifier {
  List<SearchInfo> places = [];
  bool _isLoading = false;
  // instance for them to be called
  bool checkLoading() => _isLoading;

  TextEditingController placeController = TextEditingController();
  Future<void> textChange(String? place) async {
    _isLoading = true;
    places.clear();
    if (place == null) {
      places.clear();
      return;
    }
    places = await FetcherPlaceApi().getPlaces(placeController.text);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> placeSuggestions(String place) async {
    _isLoading = true;
    places.clear();
    places = await FetcherPlaceApi().getPlaces(place);
    _isLoading = false;
    notifyListeners();
  }
}
