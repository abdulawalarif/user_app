import 'package:badges/badges.dart' as b;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/providers/cart_provider.dart';

class MyBadge {
  static Widget quarterCircle(String title, BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.elliptical(50, 50),
      ),
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.elliptical(50, 50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  static Widget cart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    int uniqueItemCount = cartProvider.totalUniqueItems;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RouteName.cartScreen);
      },
      child: Center(
        child: b.Badge(
          showBadge: true,
          badgeContent: Consumer<CartProvider>(
            builder: (context, value, child) {
              ///TODO cart
              return Text(uniqueItemCount.toString(),
                  style: const TextStyle(color: Colors.white));
            },
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
