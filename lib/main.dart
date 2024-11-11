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
 import 'ui/constants/route_name.dart';
import 'ui/constants/routes.dart';
import 'ui/constants/theme_data.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final isDarkTheme = await ThemePreferences().getTheme();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(isDarkTheme: isDarkTheme));
}
class MyApp extends StatelessWidget {
  final bool isDarkTheme;
  const MyApp({super.key, required this.isDarkTheme});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => UserDataProvider()),
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => WishlistProvider()),
            ChangeNotifierProvider(create: (_) => OrdersProvider()),
            
            ChangeNotifierProvider(
                create: (_) => ThemeChangeProvider(isDarkTheme)),
          ],
          child: Consumer<ThemeChangeProvider>(
            builder: (_, themeChangeProvider, __) {
              return Consumer<ProductProvider>(
                builder:  (_, productProvider, __) {
                  productProvider.fetchProducts();

                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Store App',
                    theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                    initialRoute: RouteName.mainScreen,
                    onGenerateRoute: Routes.generatedRoute,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}


extension Log on Object {
  void log() => devtools.log(toString());
}