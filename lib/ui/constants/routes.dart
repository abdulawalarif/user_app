import 'package:flutter/material.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/screens/buy_screen/buy_screen_main.dart';
import 'package:user_app/ui/screens/feeds.dart';
import 'package:user_app/ui/screens/inner_screens/cart.dart';
import 'package:user_app/ui/screens/inner_screens/category_screen.dart';
import 'package:user_app/ui/screens/inner_screens/forgot_password.dart';
import 'package:user_app/ui/screens/inner_screens/product_detail.dart';
import 'package:user_app/ui/screens/log_in.dart';
import 'package:user_app/ui/screens/sign_up.dart';
import 'package:user_app/ui/screens/update_users_inofrmation.dart';
import 'package:user_app/ui/screens/wishlist.dart';
import '../screens/bottom_bar.dart';
import '../screens/splash_screen.dart';
import '../utils/transition_animation.dart';

class Routes {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.mainScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => SplashScreen(),
        );
      case RouteName.bottomBarScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => BottomBarScreen(),
        );
      case RouteName.logInScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => LogInScreen(),
        );
      case RouteName.buyScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => BuyScreen(),
        );
      case RouteName.signUpScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => SignUpScreen(),
        );
      case RouteName.forgotPasswordScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => ForgotPasswordScreen(),
        );
      case RouteName.productDetailScreen:
        final String productId = settings.arguments as String;
        return SlidePageRoute(
          builder: (BuildContext context) => ProductDetailScreen(productId: productId,),
        );
      case RouteName.feedsScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => FeedsScreen(),
        );
      case RouteName.cartScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => CartScreen(),
        );

      case RouteName.wishlistScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => WishlistScreen(),
        );

      case RouteName.categoryScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => CategoryScreen(),
        );

      case RouteName.updateUserInfo:
        final UserModel userModel = settings.arguments as UserModel;
        return SlidePageRoute(
          builder: (context) => UpdateUsersInformation(userModel: userModel),
        );
      // return MaterialPageRoute(
      //   builder: (BuildContext context) =>
      //       UpdateUsersInformation(userModel: userModel),
      // );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          },
        );
    }
  }
}
