import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/style.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/db/database_helper.dart';
import 'package:submission_resto/data/model/arguments/resto_arguments.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';
import 'package:submission_resto/provider/cart_provider.dart';
import 'package:submission_resto/provider/database_provider.dart';
import 'package:submission_resto/provider/home_provider.dart';
import 'package:submission_resto/provider/order_provider.dart';
import 'package:submission_resto/provider/search_provider.dart';
import 'package:submission_resto/ui/cart_page.dart';
import 'package:submission_resto/ui/favorite_page.dart';
import 'package:submission_resto/ui/home_page.dart';
import 'package:submission_resto/ui/resto_page.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider<OrderProvider>(
            create: (context) => OrderProvider()),
        ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider()),
        ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider()),
        ChangeNotifierProvider<DatabaseProvider>(
            create: (context) =>
                DatabaseProvider(databaseHelper: DatabaseHelper()))
      ],
      child: MaterialApp(
        title: 'Restoran Nusantara',
        themeMode: themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          RestaurantPage.routeName: (context) => RestaurantPage(
                resto: ModalRoute.of(context)?.settings.arguments
                    as RestaurantsShort,
              ),
          CartPage.routeName: (context) => CartPage(
                args: ModalRoute.of(context)?.settings.arguments
                    as RestoArguments,
              ),
          FavoritePage.routeName: (context) => const FavoritePage(),
        },
      ),
    );
  }
}
