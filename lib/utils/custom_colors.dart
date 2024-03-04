import 'package:flutter/material.dart';

class CustomColors {
  static const dividerLine = Color(0xffE4E4EE);
  static const cardColor = Color(0xffE9ECF1);
  static const textColorBlack = Color(0xff171717);
  static const firstGradientColor = Color(0xff408ADE);
  static const secondGradientColor = Color(0xff5286CD);
}

class CustomStyles {
  static appStyle(
      {required BuildContext context, double? size, FontWeight? fontW}) {
    return TextStyle(
        fontSize: size,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: fontW);
  }
}
