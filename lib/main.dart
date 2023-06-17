import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/style.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/provider/home_provider.dart';
import 'package:submission_resto/ui/cart_page.dart';
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
                restaurants:
                    ModalRoute.of(context)?.settings.arguments as Restaurants,
              ),
          CartPage.routeName: (context) => CartPage(
                orders:
                    ModalRoute.of(context)?.settings.arguments as List<Order>,
              ),
        },
      ),
    );
  }
}
