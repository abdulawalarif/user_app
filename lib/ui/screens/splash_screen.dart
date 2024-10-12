import 'dart:async';
import 'package:flutter/material.dart';
 import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/providers/auth_provider.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/ui/screens/bottom_bar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    fetchingData();
     Timer(const Duration(microseconds: 100), () { /// will be 2 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBarScreen()),
      );
    });
  }

fetchingData(){
  final  _authProvider = Provider.of<AuthProvider>(context, listen: false);
  _authProvider.signInAnonymously();
  final productProvider = Provider.of<ProductProvider>(context, listen: false);
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  cartProvider.getData();
  productProvider.fetchProducts();
}

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> _productList = productProvider.products;
     return SafeArea(
       child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeArea(
              child: SizedBox(
                width: 385,
                height: 220,
                child: Image.asset('assets/icon.png'),
              ),
            ),
           SizedBox(height: 5.h,),
            const SpinKitThreeBounce(
              size: 40,
              color: Colors.blue,
            ),
          ],
        ),
    ),
     );
  }
}
