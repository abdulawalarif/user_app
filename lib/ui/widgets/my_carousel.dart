import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:user_app/core/models/carousel_model.dart';

class MyCarousel extends StatelessWidget {
  final List<CarouselModel> imageList;

  const MyCarousel({super.key, required this.imageList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: imageList
          .map(
            (item) => Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.deepPurple[50],
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
          )
          .toList(),
    );
  }
}
