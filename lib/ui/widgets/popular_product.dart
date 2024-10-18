import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/cart_model.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/models/wishlist_model.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/ui/utils/my_snackbar.dart';
import 'package:user_app/ui/widgets/my_badge.dart';
import 'package:user_app/ui/widgets/my_button.dart';

class PopularProduct extends StatelessWidget {
  const PopularProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final popularProduct = Provider.of<ProductModel>(context, listen: false);

    return Card(
      elevation: 0.6,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          RouteName.productDetailScreen,
          arguments: popularProduct.id,
        ),
        child: SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(popularProduct.imageUrls![0]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  MyBadge.quarterCircle('Top', context),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      popularProduct.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    // const Text(
                    //   //TODO will have to chage this text
                    //   'Sales {_popularProduct.sales.toString()}',
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer<CartProvider>(
                          builder: (_, cartProvider, __) => MyButton.smallIcon(
                            context: context,
                            icon: cartProvider.isInCart(popularProduct.id)
                                ? mRemoveCartIcon
                                : mAddCartIcon,
                            color: Colors.deepPurple,
                            onPressed: cartProvider.isInCart(popularProduct.id)
                                ? () {
                                    cartProvider
                                        .removeFromCart(popularProduct.id);
                                    MySnackBar().showSnackBar(
                                      'Removed from cart',
                                      context,
                                    );
                                  }
                                : () {
                                    cartProvider.addAndRemoveItem(
                                      CartModel(
                                        id: popularProduct.id,
                                        imageUrl: popularProduct.imageUrls![0],
                                        name: popularProduct.name,
                                        price: popularProduct.price,
                                      ),
                                    );
                                    MySnackBar().showSnackBar(
                                      'Added to cart',
                                      context,
                                    );
                                  },
                          ),
                        ),
                        const Spacer(),
                        Consumer<WishlistProvider>(
                          builder: (_, wishlistProvider, __) =>
                              MyButton.smallIcon(
                            context: context,
                            icon:
                                wishlistProvider.isInWishList(popularProduct.id)
                                    ? mWishListIconFill
                                    : mWishListIcon,
                            color:
                                wishlistProvider.isInWishList(popularProduct.id)
                                    ? Colors.redAccent
                                    : Theme.of(context).unselectedWidgetColor,
                            onPressed: () {
                              wishlistProvider.addAndRemoveItem(
                                WishlistModel(
                                  id: popularProduct.id,
                                  imageUrl: popularProduct.imageUrls![0],
                                  name: popularProduct.name,
                                  price: popularProduct.price,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
