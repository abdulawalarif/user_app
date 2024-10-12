import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final String title;
  final double titleFontSize;
  final Color titleColor;
  final String subTitle;
  final double subTitleFontSize;
  final Color subTitleColor;
  final IconData leading;
  final double leadingSize;
  final Color leadingColor;

  UserListTile({
    this.title = '',
    this.titleFontSize = 14,
    this.titleColor = const Color(0xFF23374D),
    this.subTitle = '',
    this.subTitleFontSize = 12,
    this.subTitleColor = const Color(0xFF8E8E8E),
    this.leading = Icons.person,
    this.leadingSize = 20,
    this.leadingColor = const Color(0xFF8E8E8E),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            leading,
            color: leadingColor,
            size: leadingSize,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: titleColor,
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: subTitleFontSize,
                    color: subTitleColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
