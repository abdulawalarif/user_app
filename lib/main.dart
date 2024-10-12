import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/core/models/theme_preferences.dart';
import 'package:user_app/core/providers/auth_provider.dart';
import 'package:user_app/core/providers/cart_provider.dart';
import 'package:user_app/core/providers/orders_provider.dart';
import 'package:user_app/core/providers/product_provider.dart';
import 'package:user_app/core/providers/theme_change_provider.dart';
import 'package:user_app/core/providers/user_data_provider.dart';
import 'package:user_app/core/providers/wishlist_provider.dart';
import 'package:user_app/firebase_options.dart';
import 'package:user_app/ui/screens/sign_up.dart';
import 'package:user_app/ui/screens/splash_screen.dart';
import 'package:user_app/ui/screens/update_users_inofrmation.dart';
import 'ui/constants/route_name.dart';
import 'ui/constants/theme_data.dart';
import 'ui/screens/bottom_bar.dart';
import 'ui/screens/buy_screen/buy_screen_main.dart';
import 'ui/screens/feeds.dart';
import 'ui/screens/inner_screens/cart.dart';
import 'ui/screens/inner_screens/category_screen.dart';
import 'ui/screens/inner_screens/forgot_password.dart';
import 'ui/screens/inner_screens/product_detail.dart';
import 'ui/screens/log_in.dart';
import 'ui/screens/wishlist.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final isDarkTheme = await ThemePreferences().getTheme();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MyApp(
      isDarkTheme: isDarkTheme,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;

  const MyApp({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ChangeNotifierProvider(
          create: (_) => ThemeChangeProvider(isDarkTheme),
          child: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => AuthProvider()),
                    ChangeNotifierProvider(create: (_) => UserDataProvider()),
                    ChangeNotifierProvider(create: (_) => ProductProvider()),
                    ChangeNotifierProvider(create: (_) => CartProvider()),
                    ChangeNotifierProvider(create: (_) => WishlistProvider()),
                    ChangeNotifierProvider(create: (_) => OrdersProvider()),
                  ],
                  child: Consumer<ThemeChangeProvider>(
                    builder: (_, themeChangeProvider, __) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Store App',
                        theme: Styles.getThemeData(
                            themeChangeProvider.isDarkTheme),
                        routes: {
                          RouteName.mainScreen: (context) => SplashScreen(),
                          RouteName.bottomBarScreen: (context) =>
                              BottomBarScreen(),
                          RouteName.logInScreen: (contex) =>
                              const LogInScreen(),
                          RouteName.buyScreen: (contex) => BuyScreen(),
                          RouteName.signUpScreen: (context) =>
                              const SignUpScreen(),
                          RouteName.forgotPasswordScreen: (context) =>
                              const ForgotPasswordScreen(),
                          RouteName.productDetailScreen: (context) =>
                              const ProductDetailScreen(),
                          RouteName.feedsScreen: (context) => FeedsScreen(),
                          RouteName.cartScreen: (context) => CartScreen(),
                          RouteName.updateUserInfo: (context) =>
                              const UpdateUsersInformation(),
                          RouteName.wishlistScreen: (context) =>
                              const WishlistScreen(),
                          RouteName.categoryScreen: (context) =>
                              CategoryScreen(),
                        },
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Consumer<ThemeChangeProvider>(
                  builder: (_, themeChangeProvider, __) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                    home: const Scaffold(
                      body: Center(child: Text('Something went wrong :(')),
                    ),
                  ),
                );
              }
              return Consumer<ThemeChangeProvider>(
                builder: (_, themeChangeProvider, __) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                  home: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
