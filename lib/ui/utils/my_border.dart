import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/theme_change_provider.dart';

class MyBorder {
  static OutlineInputBorder outlineInputBorder(BuildContext context) {
    final _isDarkTheme =
        Provider.of<ThemeChangeProvider>(context, listen: false).isDarkTheme;

    return OutlineInputBorder(
      borderSide: BorderSide(
          color: _isDarkTheme ? Color(0xFF616161) : Color(0xFF616161)),
    );
  }

  static UnderlineInputBorder underlineInputBorder(BuildContext context) {
    final _isDarkTheme =
        Provider.of<ThemeChangeProvider>(context, listen: false).isDarkTheme;

    return UnderlineInputBorder(
      borderSide: BorderSide(
          color: _isDarkTheme ? Color(0xFF616161) : Color(0xFF616161)),
    );
  }
}
