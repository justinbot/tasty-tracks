import 'package:flutter/material.dart';

ThemeData _buildTastyTracksTheme() {
  final Color primaryColor = Colors.blueGrey[900];
  final Color secondaryColor = Colors.deepPurpleAccent;
  final ColorScheme colorScheme = ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    cardColor: Colors.blueGrey[800],
    accentColor: secondaryColor,
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Colors.black,
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
//    dividerColor: Colors.white,
  );

  return base;
}

final ThemeData tastyTracksTheme = _buildTastyTracksTheme();
