import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/ui/widgets/feeds_product.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryTitle;
  const CategoryScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    List<ProductModel> _productList;
    categoryTitle.toLowerCase().contains('popular')
        ? _productList = productProvider.popularProducts
        : _productList = productProvider.findByCategory(categoryTitle);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      // body: FeedsProduct(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.width) /
              (MediaQuery.of(context).size.width + 190),
          mainAxisSpacing: 8,
          children: List.generate(
            _productList.length,
            (index) => ChangeNotifierProvider.value(
              value: _productList[index],
              child: Center(
                child: FeedsProduct(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
