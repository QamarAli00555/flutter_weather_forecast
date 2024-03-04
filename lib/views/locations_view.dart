import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/search_controller.dart';
import '../controllers/theme_controller.dart';
import '../models/Search/search.dart';
import '../utils/custom_colors.dart';
import '../utils/themes.dart';
import 'weather_view.dart';
import 'widgets/responsive_helper.dart';
import 'widgets/toast.dart';
import 'widgets/weather/custom_textfields.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  getPlaces() async {
    await SearchNotifier().placeSuggestions('Islamabad');
  }

  @override
  Widget build(BuildContext context) {
    getPlaces();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          title: Text(
            'Weather App',
            style: CustomStyles.appStyle(context: context),
          ),
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
        body:
            Consumer<SearchNotifier>(builder: (context, searchNotifier, child) {
          return Responsive(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: CustomTextField(
                          controller: searchNotifier.placeController,
                          hint: "Search location",
                          prefixIcon: Icons.location_on,
                          onChanged: searchNotifier.textChange,
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                          child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white,
                              )),
                          child: IconButton(
                              onPressed: () async {
                                await EasyLoading.show(
                                  maskType: EasyLoadingMaskType.clear,
                                );
                                double latitude = 0.0;
                                double longitude = 0.0;

                                try {
                                  bool isServiceEnabled = await Geolocator
                                      .isLocationServiceEnabled();
                                  if (!isServiceEnabled) {
                                    throw Exception(
                                        "Location services are not enabled");
                                  }

                                  LocationPermission locationPermission =
                                      await Geolocator.checkPermission();
                                  if (locationPermission ==
                                      LocationPermission.deniedForever) {
                                    showMessage(context,
                                        "Location permissions are permanently denied");
                                  } else if (locationPermission ==
                                      LocationPermission.denied) {
                                    locationPermission =
                                        await Geolocator.requestPermission();
                                    if (locationPermission ==
                                        LocationPermission.denied) {
                                      showMessage(context,
                                          "Location permissions are denied");
                                    }
                                  }

                                  Position position =
                                      await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high,
                                  );

                                  latitude = position.latitude;
                                  longitude = position.longitude;
                                  Geometry geometry = Geometry(
                                      coordinates: [longitude, latitude],
                                      type: 'Place');
                                  Properties properties =
                                      Properties(name: 'N/A');
                                  SearchInfo place = SearchInfo(
                                      geometry: geometry,
                                      properties: properties);
                                  await EasyLoading.dismiss();
                                  Get.to(() => WeatherScreen(place: place));
                                } catch (e) {
                                  showMessage(context,
                                      "Unable to get Current location");
                                  // Get.snackbar('Error',
                                  //     'Unable to get Current location [$e]',
                                  //     colorText:
                                  //         Theme.of(context).colorScheme.primary,
                                  //     backgroundColor: Theme.of(context)
                                  //         .colorScheme
                                  //         .secondary,
                                  //     icon: Icon(
                                  //       Icons.error_outline_outlined,
                                  //       color: Theme.of(context)
                                  //           .colorScheme
                                  //           .primary,
                                  //     ));
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.map_pin_ellipse,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ),
                      ))
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  context.watch<SearchNotifier>().checkLoading()
                      ? Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.3),
                          child: Center(
                            child: CupertinoActivityIndicator(
                                radius: 15,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      : context.watch<SearchNotifier>().places.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.2),
                              child: Column(
                                children: [
                                  Icon(CupertinoIcons.cloud_sun_fill,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 100),
                                  Text(
                                    'Search Places',
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomStyles.appStyle(
                                      context: context,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.separated(
                                  padding: const EdgeInsets.only(top: 20),
                                  itemBuilder: (context, index) {
                                    SearchInfo place =
                                        searchNotifier.places[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => WeatherScreen(
                                              place: place,
                                            ));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Icon(
                                              Icons.location_on,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 30,
                                            )),
                                            Expanded(
                                                flex: 3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${place.properties!.name!} (${place.properties!.country ?? '---'})',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                    ),
                                                    Text(
                                                      '${place.properties!.state ?? 'N/A'} (${place.properties!.type ?? '---'})',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary),
                                                    )
                                                  ],
                                                )),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Lat: ${double.parse(place.geometry!.coordinates![1].toString()).toStringAsFixed(1)}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                ),
                                                Text(
                                                  'Long: ${double.parse(place.geometry!.coordinates![0].toString()).toStringAsFixed(1)}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    );
                                    // ListTile(
                                    //   tileColor: Theme.of(context)
                                    //       .colorScheme
                                    //       .secondary,
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    //   onTap: () {
                                    //     Get.to(() => WeatherScreen(
                                    //           place: place,
                                    //         ));
                                    //   },
                                    //   leading: Icon(
                                    //     Icons.location_on,
                                    //     color: Theme.of(context)
                                    //         .colorScheme
                                    //         .primary
                                    //         .withOpacity(0.5),
                                    //     size: 22,
                                    //   ),
                                    //   title: Text(
                                    //     '${place.properties!.name!} (${place.properties!.country ?? '---'})',
                                    //     style: TextStyle(
                                    //         color: Theme.of(context)
                                    //             .colorScheme
                                    //             .primary),
                                    //   ),
                                    //   subtitle: Text(
                                    //     place.properties!.state ?? 'N/A',
                                    //     style: TextStyle(
                                    //         color: Theme.of(context)
                                    //             .colorScheme
                                    //             .secondary),
                                    //   ),
                                    // );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: searchNotifier.places.length))
                ],
              ),
            ),
          );
        }));
  }
}
