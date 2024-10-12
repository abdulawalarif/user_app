import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyButton {
  static Widget text({
    required BuildContext context,
    required Function() onPressed,
    String text = '',
    double height = 45,
  }) {
    return SizedBox(
      height: height,
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            )),
      ),
    );
  }

  static Widget outlined({
    required BuildContext context,
    required Function() onPressed,
    String text = '',
    double height = 45,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
            //color: Theme.of(context).buttonColor,
            width: 1),
      ),
      child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
               // color: Theme.of(context).buttonColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          )),
    );
  }

  static const Color _buttonColor = Colors.black;
  static Widget smallIcon({
    required context,
    required IconData icon,
    Color color = _buttonColor,
    required Function() onPressed,
  }) {
    return SizedBox(
      height: 25,
      width: 25,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 18,
        color: color,
        padding: EdgeInsets.zero,
        splashRadius: 14,
      ),
    );
  }

  static Widget elevatedButton(
      {required context, required child, required Function onPressed}) {
    return const Material(
      child: InkWell(),
    );
  }
}
