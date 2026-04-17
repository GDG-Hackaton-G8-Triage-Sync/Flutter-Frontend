import 'package:flutter/material.dart';

abstract final class AppIconography {
  static const IconThemeData outlined = IconThemeData(
    size: 24,
    weight: 400,
    fill: 0,
  );

  static const IconThemeData filled = IconThemeData(
    size: 24,
    weight: 400,
    fill: 1,
  );

  static Icon outlinedIcon(IconData icon, {Color? color, double? size}) {
    return Icon(icon, color: color, size: size, weight: 400, fill: 0);
  }

  static Icon filledIcon(IconData icon, {Color? color, double? size}) {
    return Icon(icon, color: color, size: size, weight: 400, fill: 1);
  }
}
