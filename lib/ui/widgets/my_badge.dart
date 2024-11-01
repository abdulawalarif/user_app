import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
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
            style:   TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  static Widget cart(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, cartProvider, __) => badges.Badge(
        
        position: badges.BadgePosition.topEnd(top: 5, end: 5),
      
        badgeContent: Text(
          cartProvider.getCartItems.length.toString(),
          style:   TextStyle(color: Theme.of(context).primaryColor,),
        ),
       
        showBadge: cartProvider.getCartItems.isEmpty ? false : true,
        child: IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteName.cartScreen),
            icon: const Icon(
              mCartIcon,
            ),),
      ),
    );
  }
}
