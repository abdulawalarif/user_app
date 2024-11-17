import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';
import 'package:user_app/ui/widgets/authenticate.dart';
import 'package:user_app/ui/widgets/empty_cart.dart';
import 'package:user_app/ui/widgets/full_cart.dart';

import '../../constants/route_name.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.getCartItems;

    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            if (cartItems.isNotEmpty)
              IconButton(
                onPressed: () => MyAlertDialog().clearCart(context, () {
                  cartProvider.removeAll();
                  Navigator.pop(context);
                }),
                icon: const Icon(mTrashIcon),
                splashRadius: 18,
              ),
          ],
        ),
        bottomSheet:
            cartItems.isNotEmpty ? checkoutSection(cartProvider) : null,
        body: cartItems.isEmpty
            ? const EmptyCart()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      bool isLastItem = index == cartItems.length - 1;
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: isLastItem ? 20.0 : 0.0),
                        child: ChangeNotifierProvider.value(
                          value: cartItems.values.toList()[index],
                          child: const FullCart(),
                        ),
                      );
                    }),
              ),
      ),
    );
  }

  Widget checkoutSection(CartProvider cartProvider) {
    return Container(
      color: Theme.of(context).cardColor,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SubTotal
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('SubTotal ',
                      style: Theme.of(context).textTheme.bodySmall),
                  Flexible(
                    child: Text(
                      '\$${cartProvider.subTotal.toString()}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Checkout Button
          Expanded(
            flex: 1,
            child: Material(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {
                  List<BuyProductModel> products =
                      cartProvider.getCartItems.values.map((cartItem) {
                    return BuyProductModel(
                      prodId: cartItem.id,
                      price: cartItem.price,
                      title: cartItem.name,
                      imageUrl: cartItem.imageUrl,
                      totalItemsOFSingleProduct: cartItem.quantity,
                    );
                  }).toList();

                  Navigator.of(context).pushNamed(
                    RouteName.productPurchaseScreen,
                    arguments: {
                      'products': products,
                      'totalPrice': cartProvider.subTotal,
                      'fromCart': true,
                    },
                  );
                },
                child: const Center(
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
