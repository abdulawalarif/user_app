import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
 import 'package:user_app/ui/screens/bottom_bar.dart';

 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  //  Provider.of<CartProvider>(context, listen: false).loadCart();
    Timer(const Duration(microseconds: 100), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomBarScreen()),
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
          mainAxisSize: MainAxisSize.min,
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
