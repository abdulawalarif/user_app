import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/models/cart_model.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/models/wishlist_model.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/utils/my_snackbar.dart';
import 'package:user_app/ui/widgets/products_images_list_on_details_view.dart';
import 'package:user_app/ui/widgets/recommendation.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final product = productProvider.findById(widget.productId);

    List<ProductModel> productRecommendation =
        productProvider.findByCategory(product.category);
    return SafeArea(
      child: Scaffold(
        bottomSheet: _bottomSheet(product),

        //original code
        /// return Scaffold( TODO will have to fix this
        //       bottomSheet: _bottomSheet(_product),
        //       body: CustomScrollView(
        //         slivers: [
        ///        SliverAppBar(
        //             expandedHeight: MediaQuery.of(context).size.width,
        //             pinned: true,
        //             elevation: 0,
        //             backgroundColor: Theme.of(context).cardColor,
        //             flexibleSpace: FlexibleSpaceBar(
        //                 background: Container(
        //               color: Colors.white,
        //               child: Image.network(
        //                 _product.imageUrl,
        //                 fit: BoxFit.contain,
        //               ),
        //             )),
        //             actions: [MyBadge.cart(context)],
        //           ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductImagesListWidget(
                    productImgList: product.imageUrls ?? []),
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
                              product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10),

                            //Product Price

                            Text(
                              '\$ ${product.price}',
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
                                          imageUrl: product.imageUrls![0],
                                          name: product.name,
                                          price: product.price,
                                        ),
                                      );
                                    },
                                    icon: wishlistProvider
                                            .isInWishList(product.id)
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
                              _detailsRow('Brand', product.brand),

                              _detailsRow('Category', product.category),
                              _detailsRow(
                                  'Popularity',
                                  product.isPopular
                                      ? 'Popular'
                                      : 'Not Popular'),

                              const SizedBox(height: 10),

                              // Description

                              Text(product.description),
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
                            itemCount: productRecommendation.length,
                            itemBuilder: (context, index) =>
                                ChangeNotifierProvider.value(
                              value: productRecommendation[index],
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: const Recommendation()),
                            ),
                          ),
                        ),
                      ),

                      _sectionContainer(
                        'Reviews',
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Text('No review yet'),
                        ),
                      ),
                      const SizedBox(height: 60),
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
              style: Theme.of(context).textTheme.bodyLarge,
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
    final cartProvider = Provider.of<CartProvider>(context);
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
                onTap: cartProvider.isInCart(product.id)
                    ? () {
                        cartProvider.removeFromCart(product.id);
                        MySnackBar().showSnackBar('Removed from cart', context);
                      }
                    : () {
                        cartProvider.addAndRemoveItem(
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
                  child: cartProvider.isInCart(product.id)
                      ? const Icon(mRemoveCartIcon)
                      : const Icon(mAddCartIcon),
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
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteName.buyScreen,
                      arguments: {
                        'products': [BuyProductModel(
                          prodId: product.id,
                          imageUrl: product.imageUrls![0],
                          title: product.name,
                          price: product.price,
                          totalItemsOFSingleProduct: 1,
                        )],
                        'totalPrice': product.price,
                      },
                    );
                  },
                  child: Center(
                    child: Text(
                      'Buy Now !'.toUpperCase(),
                      style: const TextStyle(
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
