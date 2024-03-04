import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/weather/weather_data_hourly.dart';
import '../../../utils/custom_colors.dart';

class HourlyDataWidget extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;
  const HourlyDataWidget({Key? key, required this.weatherDataHourly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.topCenter,
          child: Text("Today",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              )),
        ),
        hourlyList(context),
      ],
    );
  }

  Widget hourlyList(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataHourly.hourly.length > 12
            ? 14
            : weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(left: 10, right: 1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: CustomColors.dividerLine.withAlpha(150))
                  ],
                  gradient: 1 == index
                      ? const LinearGradient(colors: [
                          CustomColors.firstGradientColor,
                          CustomColors.secondGradientColor
                        ])
                      : null),
              child: HourlyDetails(
                index: index,
                cardIndex: 1,
                temp: weatherDataHourly.hourly[index].temp!,
                timeStamp: weatherDataHourly.hourly[index].dt!,
                weatherIcon: weatherDataHourly.hourly[index].weather![0].icon!,
              ),
            ),
          );
        },
      ),
    );
  }
}

// hourly details class
// ignore: must_be_immutable
class HourlyDetails extends StatelessWidget {
  int temp;
  int index;
  int cardIndex;
  int timeStamp;
  String weatherIcon;

  HourlyDetails(
      {Key? key,
      required this.cardIndex,
      required this.index,
      required this.timeStamp,
      required this.temp,
      required this.weatherIcon})
      : super(key: key);
  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String x = DateFormat('jm').format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(getTime(timeStamp),
              style: TextStyle(
                color: cardIndex == index
                    ? Colors.white
                    : CustomColors.textColorBlack,
              )),
        ),
        Container(
            margin: const EdgeInsets.all(5),
            child: Image.asset(
              "assets/weather/$weatherIcon.png",
              height: 40,
              width: 40,
            )),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text("$temp°",
              style: TextStyle(
                color: cardIndex == index
                    ? Colors.white
                    : CustomColors.textColorBlack,
              )),
        )
      ],
    );
  }
}
