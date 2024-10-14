import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/models/wishlist_model.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/ui/widgets/my_badge.dart';
import 'package:user_app/ui/widgets/my_button.dart';

class PopularProduct extends StatelessWidget {
  const PopularProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _popularProduct = Provider.of<ProductModel>(context, listen: false);

    return Card(
      elevation: 0.6,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          RouteName.productDetailScreen,
          arguments: _popularProduct.id,
        ),
        child: Container(
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
                            /// TODO edited imageList
                            image: NetworkImage(_popularProduct.imageUrls![0]),
                            fit: BoxFit.contain,
                          )),
                    ),
                    MyBadge.quarterCircle('Top', context)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _popularProduct.name,
                        overflow: TextOverflow.ellipsis,
                        // style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<WishlistProvider>(
                            builder: (_, wishlistProvider, __) =>
                                MyButton.smallIcon(
                              context: context,
                              icon: wishlistProvider
                                      .isInWishList(_popularProduct.id)
                                  ? mWishListIconFill
                                  : mWishListIcon,
                              color: wishlistProvider
                                      .isInWishList(_popularProduct.id)
                                  ? Colors.redAccent
                                  : Theme.of(context).unselectedWidgetColor,
                              onPressed: () {
                                wishlistProvider.addAndRemoveItem(WishlistModel(
                                  id: _popularProduct.id,

                                  /// TODO edited imageList
                                  imageUrl: _popularProduct.imageUrls![0],
                                  name: _popularProduct.name,
                                  price: _popularProduct.price,
                                ));
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
