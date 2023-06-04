import 'package:flutter/material.dart';

ThemeMode themeMode = ThemeMode.system;
Color themeColor = Colors.yellow;
// ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: themeColor);


ThemeData lightTheme = ThemeData(
  colorSchemeSeed: themeColor,
  useMaterial3: true,
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  colorSchemeSeed: themeColor,
  useMaterial3: true,
  brightness: Brightness.dark,
);
