import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> _wishListItems = {};

  Map<String, WishlistModel> get getwishListItems => _wishListItems;

  void addAndRemoveItem(WishlistModel wishlistModel) {
    isInWishList(wishlistModel.id)
        ? removeWishlistItem(wishlistModel.id)
        : _wishListItems.putIfAbsent(wishlistModel.id, () => wishlistModel);
    notifyListeners();
  }

  void removeWishlistItem(productId) {
    _wishListItems.remove(productId);
    notifyListeners();
  }

  void clearWishlist() {
    _wishListItems.clear();
    notifyListeners();
  }

  bool isInWishList(productId) => _wishListItems.containsKey(productId);
}
