import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: AssetImage('assets/images/empty_cart.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            'Your Cart is Empty',
            textAlign: TextAlign.center,
           // style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 20.0),
          Text(
            'Looks like you haven\'t added anything to your cart yet',
            textAlign: TextAlign.center,
          //  style: Theme.of(context).textTheme.overline,
          ),
        ],
      ),
    );
  }
}
