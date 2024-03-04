import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'controllers/search_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/weather_controller.dart';
import 'views/locations_view.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeNotifier()),
      ChangeNotifierProvider(create: (context) => WeatherNotifier()),
      ChangeNotifierProvider(create: (context) => SearchNotifier()),
    ],
    child: Builder(
      builder: (context) {
        // Access the ThemeNotifier to get the current theme
        final themeNotifier = Provider.of<ThemeNotifier>(context);

        // Configure loading based on the current theme
        configLoading(themeNotifier.themeData);

        // Return the main app widget
        return const MyApp();
      },
    ),
  ));
}

void configLoading(ThemeData theme) {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = theme.brightness == Brightness.light
        ? EasyLoadingStyle.light
        : EasyLoadingStyle.dark
    ..indicatorSize = 75.0
    ..radius = 30.0
    ..progressColor = Colors.transparent
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..textColor = Colors.transparent
    ..maskColor = Colors.transparent
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeNotifier>(context).themeData,
      home: const LocationsPage(),
      builder: EasyLoading.init(),
    );
  }
}
