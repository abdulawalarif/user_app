import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/ui/widgets/feeds_product.dart';


class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final _title = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> _productList;
    _title.toLowerCase().contains('popular')
        ? _productList = productProvider.popularProducts
        : _productList = productProvider.findByCategory(_title);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      // body: FeedsProduct(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
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
