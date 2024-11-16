import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/product_model.dart';
 import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/ui/widgets/feeds_product.dart';
import 'package:user_app/ui/widgets/my_badge.dart';

class FeedsScreen extends StatefulWidget {
  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> productList = productProvider.products;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeds',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MyBadge.cart(context),
        )],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
       body: Container(
        margin:const EdgeInsets.symmetric(horizontal: 8),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.width) /
              (MediaQuery.of(context).size.width + 184),
          mainAxisSpacing: 8,
          children: List.generate(
            productList.length,
            (index) => ChangeNotifierProvider.value(
              value: productList[index],
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
