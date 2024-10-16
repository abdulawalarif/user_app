import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/cart_model.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/models/wishlist_model.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/utils/my_snackbar.dart';
import 'package:user_app/ui/widgets/products_images_list_on_details_view.dart';
import 'package:user_app/ui/widgets/recommendation.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final _product = _productProvider.findById(widget.productId);

    List<ProductModel> _productRecommendation =
        _productProvider.findByCategory(_product.category);
    return SafeArea(
      child: Scaffold(
        bottomSheet: _bottomSheet(_product),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductImagesListWidget(
                    productImgList: _product.imageUrls ?? []),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Product Name
                            Text(
                              _product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              // style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(height: 10),

                            //Product Price

                            Text(
                              '\$ ${_product.price}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Product sales and Wishlist Button

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Consumer<WishlistProvider>(
                                  builder: (_, wishlistProvider, __) =>
                                      IconButton(
                                    onPressed: () {
                                      wishlistProvider.addAndRemoveItem(
                                        WishlistModel(
                                          id: widget.productId,

                                          /// TODO edited imageList
                                          imageUrl: _product.imageUrls![0],
                                          name: _product.name,
                                          price: _product.price,
                                        ),
                                      );
                                    },
                                    icon: wishlistProvider
                                            .isInWishList(_product.id)
                                        ? const Icon(
                                            mWishListIconFill,
                                            color: Colors.redAccent,
                                          )
                                        : const Icon(mWishListIcon),
                                    splashRadius: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Details and Description

                      _sectionContainer(
                        'Details',
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsRow('Brand', _product.brand),

                              _detailsRow('Category', _product.category),
                              _detailsRow(
                                  'Popularity',
                                  _product.isPopular
                                      ? 'Popular'
                                      : 'Not Popular'),

                              const SizedBox(height: 10),

                              // Description

                              Text(_product.description),
                            ],
                          ),
                        ),
                      ),

                      //Product Recommendations

                      _sectionContainer(
                        'Recommendations',
                        Container(
                          height: MediaQuery.of(context).size.width * 0.45 + 60,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            itemCount: _productRecommendation.length,
                            itemBuilder: (context, index) =>
                                ChangeNotifierProvider.value(
                              value: _productRecommendation[index],
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Recommendation()),
                            ),
                          ),
                        ),
                      ),

                      _sectionContainer(
                          'Reviews',
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('No review yet'),
                          )),
                      SizedBox(height: 60),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionContainer(String title, Widget child) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              title.toUpperCase(),
              //style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          const SizedBox(height: 10),
          child,
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _detailsRow(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(key)),
          Expanded(flex: 2, child: Text(value)),
        ],
      ),
    );
  }

  Widget _bottomSheet(ProductModel product) {
    final _cartProvider = Provider.of<CartProvider>(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 50,
      child: Row(
        children: [
          // Add to cart button
          Expanded(
            flex: 1,
            child: Material(
              color: Theme.of(context).cardColor,
              child: InkWell(
                onTap: _cartProvider.isInCart(product.id)
                    ? () {
                        _cartProvider.removeFromCart(product.id);
                        MySnackBar().showSnackBar('Removed from cart', context);
                      }
                    : () {
                        _cartProvider.addAndRemoveItem(
                          CartModel(
                            id: product.id,
                            imageUrl: product.imageUrls![0],
                            name: product.name,
                            price: product.price,
                          ),
                        );
                        MySnackBar().showSnackBar('Added to cart', context);
                      },
                child: Center(
                  child: _cartProvider.isInCart(product.id)
                      ? Icon(mRemoveCartIcon)
                      : Icon(mAddCartIcon),
                ),
              ),
            ),
          ),

          // Buy button
          Expanded(
            flex: 1,
            child: Material(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                  onTap: () {},
                  child: Center(
                    child: Text(
                      'Buy Now !'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
