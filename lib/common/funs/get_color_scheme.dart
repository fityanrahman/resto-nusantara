import 'package:flutter/material.dart';
import 'package:submission_resto/common/style.dart';

ColorScheme getCurrentColorScheme(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  ThemeData themeData = lightTheme;
  isDarkMode == true ? themeData = darkTheme : lightTheme;

  var colorScheme = themeData.colorScheme;

  return colorScheme;
}