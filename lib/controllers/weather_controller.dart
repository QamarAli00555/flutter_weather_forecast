import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather/weather_data.dart';
import '../services/fetch_weather.dart';

class WeatherNotifier extends ChangeNotifier {
  // create various variables
  bool _isLoading = true;
  double _lattitude = 0.0;
  double _longitude = 0.0;
  final int _currentIndex = 0;

  // instance for them to be called
  bool checkLoading() => _isLoading;
  double getLattitude() => _lattitude;
  double getLongitude() => _longitude;

  WeatherData? weatherData = WeatherData();

  WeatherData getData() {
    return weatherData!;
  }

  void onInit() {
    if (_isLoading) {
      getLocation(_lattitude, _longitude);
    } else {
      getIndex();
    }
  }

  Future<WeatherData> getLocation(double? lat, double? log) async {
    if (lat != null && log != null) {
      //If not current location
      weatherData = await FetchWeatherAPI().processData(lat, log).then((value) {
        weatherData = value;
        _isLoading = false;
        return value;
      });
      return weatherData!;
    }

    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    // return if service is not enabled
    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }

    // status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission are denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      // request permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission is denied");
      }
    }

    // getting the currentposition
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) async {
      // update our lattitude and longitude
      _lattitude = value.latitude;
      _longitude = value.longitude;
      // calling our weather api
      weatherData = await FetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((value) {
        weatherData = value;
        _isLoading = false;
        return value;
      });
      return weatherData!;
    });
  }

  int getIndex() {
    return _currentIndex;
  }
}
