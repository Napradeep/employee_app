import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastHelper {
  static void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = Colors.red,
    Color textColor = Colors.white,
    int durationSeconds = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength:
          durationSeconds == 1 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
