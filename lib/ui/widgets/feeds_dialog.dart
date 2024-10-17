import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/cart_model.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/core/models/wishlist_model.dart';
import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/ui/widgets/my_button.dart';

class FeedsDialog extends StatelessWidget {
  final String productId;
  const FeedsDialog({super.key, this.productId = ''});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context).findById(productId);
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(product.imageUrls![0]),
                            fit: BoxFit.contain,),),
                  ),
                  Positioned(
                    right: 2,
                    child: MyButton.smallIcon(
                      context: context,
                      icon: mCloseIcon,
                      onPressed: () => Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null,
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Material(
                        child: Consumer<WishlistProvider>(
                          builder: (_, wishlistProvider, __) => InkWell(
                            onTap: () =>
                                wishlistProvider.addAndRemoveItem(WishlistModel(
                              id: product.id,
                              imageUrl: product.imageUrls![0],
                              name: product.name,
                              price: product.price,
                            ),),
                            child: Center(
                              child: wishlistProvider.isInWishList(productId)
                                  ? const Icon(mWishListIconFill,
                                      color: Colors.redAccent,)
                                  : const Icon(mWishListIcon),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(
                      flex: 1,
                      child: Material(
                        child: Consumer<CartProvider>(
                          builder: (_, cartProvider, __) => InkWell(
                            onTap: () =>
                                cartProvider.addAndRemoveItem(CartModel(
                              id: product.id,
                              imageUrl: product.imageUrls![0],
                              name: product.name,
                              price: product.price,
                            ),),
                            child: Center(
                              child: cartProvider.isInCart(productId)
                                  ? Icon(mRemoveCartIcon,
                                      color: Theme.of(context).primaryColor,)
                                  : const Icon(mAddCartIcon),
                            ),
                          ),
                        ),
                      ),
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
