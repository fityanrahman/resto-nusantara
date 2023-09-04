import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_resto/common/navigation.dart';
import 'package:submission_resto/common/style.dart';
import 'package:submission_resto/common/utils/background_service.dart';
import 'package:submission_resto/common/utils/notification_helper.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/db/database_helper.dart';
import 'package:submission_resto/data/model/arguments/resto_arguments.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';
import 'package:submission_resto/data/preferences/preferences_helper.dart';
import 'package:submission_resto/provider/cart_provider.dart';
import 'package:submission_resto/provider/database_provider.dart';
import 'package:submission_resto/provider/home_provider.dart';
import 'package:submission_resto/provider/order_provider.dart';
import 'package:submission_resto/provider/preferences_provider.dart';
import 'package:submission_resto/provider/scheduling_provider.dart';
import 'package:submission_resto/provider/search_provider.dart';
import 'package:submission_resto/ui/cart_page.dart';
import 'package:submission_resto/ui/favorite_page.dart';
import 'package:submission_resto/ui/home_page.dart';
import 'package:submission_resto/ui/resto_page.dart';
import 'package:submission_resto/ui/setting_page.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializationIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotification(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final http.Client httpClient = http.Client();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(apiService: ApiService(httpClient: httpClient)),
        ),
        ChangeNotifierProvider<OrderProvider>(
            create: (context) => OrderProvider()),
        ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider()),
        ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider()),
        ChangeNotifierProvider<DatabaseProvider>(
            create: (context) =>
                DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider<PreferencesProvider>(
          create: (context) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance()),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider()),
      ],
      child: MaterialApp(
        title: 'Restoran Nusantara',
        themeMode: themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        navigatorKey: navigatorKey,
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
          SettingsPage.routeName: (context) => const SettingsPage(),
        },
      ),
    );
  }
}
