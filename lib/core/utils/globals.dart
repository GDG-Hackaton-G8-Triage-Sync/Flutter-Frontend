import 'package:flutter/material.dart';

/// Global root navigator key used for forcing navigation
/// from outside Flutter's widget tree (e.g., from Dio interceptors).
final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();
