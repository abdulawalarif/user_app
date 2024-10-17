import 'package:flutter/material.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/category_model.dart';

class Category extends StatelessWidget {
  final CategoryModel category;
  const Category({super.key, required this.category});
  @override
  Widget build(BuildContext context) {
    double imageSize = 50;
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        RouteName.categoryScreen,
        arguments: category.title,
      ),
      child: SizedBox(
        width: imageSize + 15,
        child: Column(
          children: [
            Container(
              height: imageSize,
              width: imageSize,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                color: Colors.deepPurple[50],
              ),
              child: Center(
                child: Image.asset(
                  category.image,
                  width: imageSize * 0.65,
                  height: imageSize * 0.65,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
