import 'package:flutter/material.dart';
import 'package:user_app/core/models/brand_model.dart';

class PopularBrand extends StatelessWidget {
  final BrandModel brand;

  const PopularBrand({super.key,  required this.brand});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            image: DecorationImage(
              image: NetworkImage(brand.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Positioned(
          right: 10,
          top: 4,
          child: Icon(
            Icons.star,
            color: Colors.amberAccent,
            size: 16,
          ),
        ),
      ],
    );
  }
}
