import 'package:flutter/material.dart';
import 'package:flutter_weather_app/utils/themes.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void switchTheme() {
    _themeData == lightMode ? _themeData = darkMode : _themeData = lightMode;
    notifyListeners();
  }
}
