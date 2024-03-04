import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMessage(BuildContext context, String message) {
  Get.snackbar('Error', message,
      colorText: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      icon: Icon(
        Icons.error_outline_outlined,
        color: Theme.of(context).colorScheme.primary,
      ));
}
