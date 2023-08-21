import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/style.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/provider/home_provider.dart';
import 'package:submission_resto/provider/order_provider.dart';
import 'package:submission_resto/provider/search_provider.dart';
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
        ChangeNotifierProvider<OrderProvider>(
            create: (context) => OrderProvider()),
        ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider()),
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
                idResto: ModalRoute.of(context)?.settings.arguments as String,
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
