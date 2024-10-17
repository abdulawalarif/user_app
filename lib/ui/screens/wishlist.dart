import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/ui/widgets/empty_wishlist.dart';
import 'package:user_app/ui/widgets/full_wishlist.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          if (wishlistProvider.getwishListItems.isNotEmpty)
            IconButton(
              onPressed: () => wishlistProvider.clearWishlist(),
              icon: const Icon(mTrashIcon),
              splashRadius: 18,
            ),
        ],
      ),
      body: wishlistProvider.getwishListItems.isEmpty
          ? const EmptyWishlist()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                children: List.generate(
                  wishlistProvider.getwishListItems.length,
                  (index) => ChangeNotifierProvider.value(
                    value: wishlistProvider.getwishListItems.values
                        .toList()[index],
                    child: const FullWishlist(),
                  ),
                ),
              ),
            ),
    );
  }
}
