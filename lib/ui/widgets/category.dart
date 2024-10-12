import 'package:flutter/material.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/category_model.dart';

class Category extends StatelessWidget {
  final CategoryModel category;
  Category({required this.category});
  @override
  Widget build(BuildContext context) {
    double _imageSize = 50;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, RouteName.categoryScreen,
          arguments: category.title),
      child: Container(
        width: _imageSize + 15,
        child: Column(
          children: [
            Container(
              height: _imageSize,
              width: _imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.deepPurple[50],
              ),
              child: Center(
                child: Image.asset(
                  category.image,
                  width: _imageSize * 0.65,
                  height: _imageSize * 0.65,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              category.title,
             // style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
