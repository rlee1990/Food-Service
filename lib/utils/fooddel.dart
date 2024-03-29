import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodDel {
  static const String app_name = "Food Del";
  static const String app_version = "Version 1.0.0";
  static const int app_version_code = 1;
  static const Color app_color = Colors.green;
  static const Color primaryAppColor = Colors.white;
  static const Color secondaryAppColor = Colors.black;
  static const String raleway_family = 'Raleway';
  static bool isDebugMode = true;

  //* Preferences
  static SharedPreferences prefs;
  static const String darkModePref = "foodDelDarkModePref";
}