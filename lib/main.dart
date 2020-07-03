import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geofancing/src/app.dart';

import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}