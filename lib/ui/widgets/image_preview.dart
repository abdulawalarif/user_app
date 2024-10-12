import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom widget to show the preview of image from the device memory

class ImagePreview extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  const ImagePreview(
      {Key? key, this.imagePath = '', this.width = 100, this.height = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        color: Colors.grey[200],
        image: imagePath.isNotEmpty && !kIsWeb
            ? DecorationImage(
                image: FileImage(File(imagePath)), fit: BoxFit.cover)
            : imagePath.isNotEmpty && kIsWeb
                ? DecorationImage(
                    image: NetworkImage(imagePath), fit: BoxFit.cover)
                : null,
      ),
    );
  }
}
