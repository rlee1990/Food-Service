import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_dev/utils/fooddel.dart';

class ThemeState with ChangeNotifier {
  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFFEC3558),
    fontFamily: 'Raleway'
  );
  ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFFEC3558),
    brightness: Brightness.light,
    fontFamily: 'Raleway'
  );

  ThemeData _themeData;
  bool isDark = FoodDel.prefs.getBool(FoodDel.darkModePref) ?? false;

  ThemeState() {
    _themeData = darkTheme;
  }

  ThemeData getTheme() => _themeData;

  setTheme() {
    if (!isDark) {
      FoodDel.prefs.setBool(FoodDel.darkModePref, true);
    } else {
      FoodDel.prefs.setBool(FoodDel.darkModePref, false);
    }
    isDark = !isDark;
    notifyListeners();
  }
}