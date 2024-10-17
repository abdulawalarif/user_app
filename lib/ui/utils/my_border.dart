import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/theme_change_provider.dart';

class MyBorder {
  static OutlineInputBorder outlineInputBorder(BuildContext context) {
    final isDarkTheme =
        Provider.of<ThemeChangeProvider>(context, listen: false).isDarkTheme;

    return OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkTheme ? const Color(0xFF616161) : const Color(0xFF616161),
      ),
    );
  }

  static UnderlineInputBorder underlineInputBorder(BuildContext context) {
    final isDarkTheme =
        Provider.of<ThemeChangeProvider>(context, listen: false).isDarkTheme;

    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: isDarkTheme ? const Color(0xFF616161) : const Color(0xFF616161),
      ),
    );
  }
}
