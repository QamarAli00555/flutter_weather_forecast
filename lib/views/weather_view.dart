// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/theme_controller.dart';
import '../controllers/weather_controller.dart';
import '../models/Search/search.dart';
import '../models/weather/weather_data.dart';
import '../utils/custom_colors.dart';
import '../utils/themes.dart';
import 'widgets/loader.dart';
import 'widgets/weather/comfort_level.dart';
import 'widgets/weather/current_weather_widget.dart';
import 'widgets/weather/daily_data_forecast.dart';
import 'widgets/weather/header_widget.dart';
import 'widgets/weather/hourly_data_widget.dart';

class WeatherScreen extends StatefulWidget {
  final SearchInfo place;
  const WeatherScreen({Key? key, required this.place}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<WeatherData>? weatherInfo;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  getWeather() {
    double lat = widget.place.geometry!.coordinates![0];
    double long = widget.place.geometry!.coordinates![1];
    WeatherNotifier().getLocation(lat, long);
  }

  @override
  Widget build(BuildContext context) {
    double long = widget.place.geometry!.coordinates![0];
    double lat = widget.place.geometry!.coordinates![1];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: Text(
          'Weather Info',
          style: CustomStyles.appStyle(context: context),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .switchTheme();
                },
                icon: Icon(
                  Provider.of<ThemeNotifier>(context, listen: false)
                              .themeData ==
                          lightMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                )),
          )
        ],
      ),
      body: Consumer<WeatherNotifier>(
        builder: (context, weatherNotifier, child) {
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: SafeArea(
                child: FutureBuilder<WeatherData>(
                    future: WeatherNotifier().getLocation(lat, long),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          WeatherNotifier().weatherData == null) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.cloud_sun_fill,
                                color: Theme.of(context).colorScheme.primary,
                                size: 100),
                            const SizedBox(
                              height: 20,
                            ),
                            CupertinoActivityIndicator(
                              radius: 15,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: NoSearchResults(text: 'No Result found'),
                        );
                      } else if (snapshot.hasData) {
                        final info =
                            snapshot.data ?? WeatherNotifier().weatherData;
                        return Center(
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: [
                              HeaderWidget(
                                  city: widget.place.properties!.name!),
                              // for our current temp ('current')
                              CurrentWeatherWidget(
                                weatherDataCurrent: info!.getCurrentWeather(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              HourlyDataWidget(
                                  weatherDataHourly: info.getHourlyWeather()),
                              DailyDataForecast(
                                weatherDataDaily: info.getDailyWeather(),
                              ),
                              Container(
                                height: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ComfortLevel(
                                  weatherDataCurrent: info.getCurrentWeather())
                            ],
                          ),
                        );
                      }
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/clouds.png",
                            height: 200,
                            width: 200,
                          ),
                          CupertinoActivityIndicator(
                            radius: 15,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        ],
                      ));
                    })),
          );
        },
      ),
    );
  }
}
