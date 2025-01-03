import 'package:flutter/material.dart';
import 'package:user_app/core/models/buy_product_model.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/screens/product_purchase_screen.dart';
import 'package:user_app/ui/screens/feeds.dart';
import 'package:user_app/ui/screens/inner_screens/cart.dart';
import 'package:user_app/ui/screens/inner_screens/category_screen.dart';
import 'package:user_app/ui/screens/inner_screens/forgot_password.dart';
import 'package:user_app/ui/screens/inner_screens/product_detail.dart';
import 'package:user_app/ui/screens/log_in.dart';
import 'package:user_app/ui/screens/sign_up.dart';
import 'package:user_app/ui/screens/update_users_inofrmation.dart';
import 'package:user_app/ui/screens/wishlist.dart';
import '../../core/models/orders_model.dart';
import '../screens/bottom_bar.dart';
import '../screens/inner_screens/my_orders_status_screen.dart';
import '../screens/my_orders_screen.dart';
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
          builder: (BuildContext context) => const BottomBarScreen(),
        );
      case RouteName.logInScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => const LogInScreen(),
        );
      case RouteName.productPurchaseScreen:
        Map<String, Object>? args = settings.arguments as Map<String, Object>;
        List<BuyProductModel> products =
            args['products'] as List<BuyProductModel>;
        double totalPrice = args['totalPrice'] as double;
        bool fromCart = args['fromCart'] as bool;
        return SlidePageRoute(
          builder: (BuildContext context) => ProductPurchaseScreen(
            products: products,
            totalPrice: totalPrice,
            fromCart: fromCart,
          ),
        );
      case RouteName.signUpScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => const SignUpScreen(),
        );
      case RouteName.forgotPasswordScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => const ForgotPasswordScreen(),
        );
      case RouteName.productDetailScreen:
        final String productId = settings.arguments as String;
        return SlidePageRoute(
          builder: (BuildContext context) => ProductDetailScreen(
            productId: productId,
          ),
        );
      case RouteName.feedsScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => FeedsScreen(),
        );

      case RouteName.cartScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => const CartScreen(),
        );
         case RouteName.myOrdersScreen:
               Map<String, Object>? args = settings.arguments as Map<String, Object>;
        String userId = args['userId'] as String;
        return SlidePageRoute(
          builder: (BuildContext context) =>   MyOrdersScreen(userId: userId,),
        );
      case RouteName.ordersStatusScreen:
        Map<String, Object>? args = settings.arguments as Map<String, Object>;
        OrdersModel ordersModel = args['OrdersModel'] as OrdersModel;
     

        return SlidePageRoute(
          builder: (BuildContext context) => MyOrdersStatusScreen(
            ordersModel: ordersModel
          ),
        );

      case RouteName.wishlistScreen:
        return SlidePageRoute(
          builder: (BuildContext context) => const WishlistScreen(),
        );

      case RouteName.categoryScreen:
        final String categoryName = settings.arguments as String;
        return SlidePageRoute(
          builder: (BuildContext context) =>
              CategoryScreen(categoryTitle: categoryName),
        );

      case RouteName.updateUserInfo:
        final UserModel userModel = settings.arguments as UserModel;
        return SlidePageRoute(
          builder: (context) => UpdateUsersInformation(userModel: userModel),
        );
      

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
