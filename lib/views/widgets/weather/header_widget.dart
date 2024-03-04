import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderWidget extends StatefulWidget {
  final String city;
  const HeaderWidget({Key? key, required this.city}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String date = DateFormat("yMMMMd").format(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  // getAddress(lat, lon) async {
  //   List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
  //   Placemark place = placemark[0];
  //   setState(() {
  //     city = place.locality!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.topLeft,
          child: Text(
            widget.city,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 35,
                height: 2),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          alignment: Alignment.topLeft,
          child: Text(
            date,
            style:
                TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
        ),
      ],
    );
  }
}
