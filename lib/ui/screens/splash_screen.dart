import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
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

    Timer(const Duration(microseconds: 100), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBarScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
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
