import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/cart_model.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';
import 'package:user_app/ui/widgets/my_button.dart';


class FullCart extends StatefulWidget {
  const FullCart({Key? key}) : super(key: key);

  @override
  _FullCartState createState() => _FullCartState();
}

class _FullCartState extends State<FullCart> {
  @override
  Widget build(BuildContext context) {
    final _cartItem = Provider.of<CartModel>(context, listen: false);
    final _cartProvider = Provider.of<CartProvider>(context);
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      height: 110,
      child: Card(
        child: InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteName.productDetailScreen,
              arguments: _cartItem.id),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(_cartItem.imageUrl),
                            fit: BoxFit.contain)),
                  ),
                  MyButton.smallIcon(
                    context: context,
                    icon: mIconDelete,
                    color: Colors.redAccent,
                    onPressed: () =>
                          MyAlertDialog().removeCartItem(context, () {
                          _cartProvider.removeFromCart(_cartItem.id);
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _cartItem.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                             // style: Theme.of(context).textTheme.bodyText1,
                              /// TODO theme fixing here
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Price: ',
                          ),
                          Text(
                            '\$${_cartItem.price}',
                           // style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyButton.smallIcon(
                            context: context,
                            icon: mIconRemove,
                            color: _cartItem.quantity > 1
                                ? Colors.redAccent
                                : Theme.of(context).disabledColor,
                            onPressed: _cartItem.quantity > 1
                                ? () {
                              _cartItem.quantity--;
                              _cartProvider.updateCart(_cartItem);
                            }
                                : () {},
                          ),
                          Container(
                            width: 40,
                            height: 20,
                            child: TextField(
                              // onChanged: (value) {
                              //   if (value.isNotEmpty) {
                              //     _cartItem.quantity = int.parse(value);
                              //     _cartProvider.addToCart(_cartItem);
                              //   }
                              // },
                              enabled: false,
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: _cartItem.quantity.toString()),
                              maxLines: 1,
                          //    style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.deepPurple,
                                isDense: true,
                                contentPadding: EdgeInsets.only(top: 2),
                              ),
                            ),
                          ),
                          MyButton.smallIcon(
                            context: context,
                            icon: mIconAdd,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              _cartItem.quantity++;
                              _cartProvider.updateCart(_cartItem);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
