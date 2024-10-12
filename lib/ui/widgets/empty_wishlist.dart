import 'package:flutter/material.dart';

class EmptyWishlist extends StatefulWidget {
  @override
  _EmptyWishlistState createState() => _EmptyWishlistState();
}

class _EmptyWishlistState extends State<EmptyWishlist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/empty_wishlist.png'),
                ),
              ),
            ),
            Text(
              'Your Wishlist is Empty',
              textAlign: TextAlign.center,
            //  style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20.0),
            Text(
              'Looks like you haven\'t added anything to your wishlist yet',
              textAlign: TextAlign.center,
           //   style: Theme.of(context).textTheme.overline,
            ),
          ],
        ),
      ),
    );
  }
}
