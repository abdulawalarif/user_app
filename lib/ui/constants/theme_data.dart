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
      titleLarge: TextStyle(
        color: _primaryColor,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      secondary: _primaryColor,
      tertiary: Colors.grey[700],
    ),
    primaryIconTheme: const IconThemeData(color: _primaryColor),
    scaffoldBackgroundColor: Colors.grey[50],
    canvasColor: Colors.white,
    unselectedWidgetColor: Colors.grey[600],
    cardColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[500]),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    textTheme: TextTheme(
      bodyLarge: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      bodyMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      headlineSmall: TextStyle(
          color: Colors.grey[900],
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8),
      headlineMedium: const TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      headlineLarge: const TextStyle(
          color: _primaryColor, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.grey[700], fontSize: 14),
      titleMedium: TextStyle(color: Colors.grey[700]),
      titleSmall:
      TextStyle(color: Colors.grey[600], fontWeight: FontWeight.normal),
      labelSmall:
      TextStyle(fontSize: 12.0, color: Colors.grey[600], letterSpacing: 1),
      bodySmall: TextStyle(fontSize: 12, color: Colors.grey[600]),
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0.0, iconTheme: IconThemeData(color: _primaryColor)),
    iconTheme: IconThemeData(color: Colors.grey[700]),
  );


  static ThemeData darkTheme = ThemeData(
    primarySwatch: _primaryColor,
    primaryColor: _primaryColor,
    colorScheme: ColorScheme.dark(
      secondary: _primaryColor,
      tertiary: Colors.grey[600],
    ),
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(
        color: _primaryColor,
      ),
    ),
    dialogBackgroundColor: Colors.grey[900],
    primaryIconTheme: const IconThemeData(color: _primaryColor),
    scaffoldBackgroundColor: const Color(0xFF151515),
    cardColor: Colors.black,
    canvasColor: Colors.black,
    secondaryHeaderColor: Colors.grey[300],
    unselectedWidgetColor: Colors.grey[300],
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[500]),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    textTheme: TextTheme(
      bodyLarge: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      bodyMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[400]),
      headlineSmall: TextStyle(
          color: Colors.grey[200],
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8),
      headlineMedium: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      headlineLarge: const TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.grey[300], fontSize: 14),
      titleMedium: TextStyle(color: Colors.grey[300]),
      titleSmall:
      TextStyle(color: Colors.grey[350], fontWeight: FontWeight.normal),
      labelSmall:
      TextStyle(fontSize: 12.0, color: Colors.grey[500], letterSpacing: 1),
      bodySmall: TextStyle(fontSize: 12, color: Colors.grey[400]),
    ),
    appBarTheme: const AppBarTheme(elevation: 0.0),
    iconTheme: IconThemeData(color: Colors.grey[300]),
  );

}
