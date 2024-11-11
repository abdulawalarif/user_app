import 'package:flutter/material.dart';

class Styles {
  static const MaterialColor _primaryColor = Colors.deepPurple;
  static ThemeData getThemeData(bool isDarkTheme) {
    return isDarkTheme ? darkTheme : lightTheme;
  }

static ThemeData lightTheme = ThemeData(
  primarySwatch: _primaryColor,
  primaryColor: _primaryColor,
  primaryTextTheme: const TextTheme(
    titleLarge: TextStyle(color: _primaryColor),
  ),
  colorScheme: ColorScheme.light(
    primary: _primaryColor,
    secondary: _primaryColor,
    tertiary: Colors.grey[700]!,
  ),
  scaffoldBackgroundColor: Colors.grey[50],
  canvasColor: Colors.white,
  dividerColor: _primaryColor,  // Add divider color
  highlightColor: Colors.grey[200]!, // For button highlights
  textTheme: TextTheme(
    bodyLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[800]),
    headlineSmall: TextStyle(color: Colors.grey[900], fontSize: 16, fontWeight: FontWeight.bold),
    titleLarge: const TextStyle(color: _primaryColor, fontSize: 14),
  ),
);

static ThemeData darkTheme = ThemeData(
  primarySwatch: _primaryColor,
  primaryColor: _primaryColor,
  colorScheme: ColorScheme.dark(
    secondary: _primaryColor,
    tertiary: Colors.grey[600]!,
  ),
  scaffoldBackgroundColor: const Color(0xFF151515),
  cardColor: Colors.black,
  dividerColor: _primaryColor,  // Add divider color
  highlightColor: Colors.grey[600]!, // For button highlights
  textTheme: TextTheme(
    bodyLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[400]),
    headlineSmall: TextStyle(color: Colors.grey[200], fontSize: 16, fontWeight: FontWeight.bold),
    titleLarge: const TextStyle(color: _primaryColor, fontSize: 14),
  ),
);

}
