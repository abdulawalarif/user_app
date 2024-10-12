import 'package:flutter/material.dart';

class MySnackBar {
  Future<void> showSnackBar(String content, BuildContext context,
      {Duration duration = const Duration(milliseconds: 500)}) async {
    double horizontalMargin = MediaQuery.of(context).size.width * 0.3;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.grey[300]),
          const SizedBox(height: 2),
          Text(
            content.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[300],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
      margin: EdgeInsets.fromLTRB(horizontalMargin, 0, horizontalMargin,
          MediaQuery.of(context).size.height * 0.5),
    ));
  }
}
