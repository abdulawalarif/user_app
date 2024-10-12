import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/core/models/cart_model.dart';
import 'package:user_app/core/models/wishlist_model.dart';
import 'package:user_app/core/services/db_helper_cart.dart';
  import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
 import 'package:user_app/core/providers/cart_provider.dart';
 import 'package:user_app/ui/widgets/my_button.dart';

class FeedsDialog extends StatefulWidget {
  final String productId;
  const FeedsDialog({Key? key, this.productId = ''}) : super(key: key);

  @override
  State<FeedsDialog> createState() => _FeedsDialogState();
}

class _FeedsDialogState extends State<FeedsDialog> {
  DBHelperCart? dbHelper = DBHelperCart();

  @override
  void initState() {
    super.initState();
    dbHelper?.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<ProductProvider>(context).findById(widget.productId);
    final cart  = Provider.of<CartProvider>(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: SingleChildScrollView(
        child: Container(
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
                          /// TODO edited imageList
                            image: NetworkImage(_product.imageUrls![0]),
                            fit: BoxFit.contain)),
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
                  )
                ],
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Material(
                        child: Consumer<WishlistProvider>(
                          builder: (_, wishlistProvider, __) => InkWell(
                            onTap: () =>
                                wishlistProvider.addAndRemoveItem(WishlistModel(
                              id: _product.id,
                                  /// TODO edited imageList
                              imageUrl: _product.imageUrls![0],
                              name: _product.name,
                              price: _product.price,
                             )),
                            child: Center(
                              child: wishlistProvider.isInWishList(widget.productId)
                                  ? Icon(mWishListIconFill,
                                      color: Colors.redAccent)
                                  : Icon(mWishListIcon),
                            ),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(width: 1, thickness: 1),
                    Expanded(
                      flex: 1,
                      child: Material(
                        child: Consumer<CartProvider>(
                          builder: (_, cartProvider, __) => InkWell(
                            onTap: (){
                              dbHelper!.insert(
                                  Cart(
                                      productId: _product.id,
                                      productName: _product.name,
                                      initialPrice: _product.price.toInt(),
                                      productPrice: _product.price.toInt(),
                                      quantity: 1,
                                      image:  _product.imageUrls![0])
                              ).then((value){

                                cart.addTotalPrice(double.parse(_product.price.toString()));
                                cart.addCounter();

                                final snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Product is added to cart'), duration: Duration(seconds: 1),);

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              }).onError((error, stackTrace){
                                print("error"+error.toString());
                                final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Product is already added in cart'), duration: Duration(seconds: 1));

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              });
                            },
                            child: const Center(
                              child: Icon(mAddCartIcon),
                            ),

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
