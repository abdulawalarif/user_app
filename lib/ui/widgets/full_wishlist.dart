import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/wishlist_model.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/ui/widgets/my_button.dart';

class FullWishlist extends StatelessWidget {
  const FullWishlist({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistItem = Provider.of<WishlistModel>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    double cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Material(
        elevation: 0.4,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            RouteName.productDetailScreen,
            arguments: wishlistItem.id,
          ),
          child: SizedBox(
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: cardWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(wishlistItem.imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wishlistItem.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${wishlistItem.price.toString()}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyButton.smallIcon(
                            context: context,
                            icon: Icons.favorite,
                            color: Colors.redAccent,
                            onPressed: () =>
                                wishlistProvider.addAndRemoveItem(wishlistItem),
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
      ),
    );
  }
}
