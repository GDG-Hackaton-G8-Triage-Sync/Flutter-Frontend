import 'package:flutter/material.dart';

abstract final class AppRadii {
  static const double defaultRadius = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double x2l = 16.0;
  static const double x3l = 24.0;
  static const double full = 9999.0;

  static const BorderRadius defaultBorder = BorderRadius.all(
    Radius.circular(defaultRadius),
  );
  static const BorderRadius lgBorder = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlBorder = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius x2lBorder = BorderRadius.all(Radius.circular(x2l));
  static const BorderRadius x3lBorder = BorderRadius.all(Radius.circular(x3l));
  static const BorderRadius fullBorder = BorderRadius.all(
    Radius.circular(full),
  );
}
