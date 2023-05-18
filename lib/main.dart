import 'package:flutter/material.dart';
import 'package:submission_resto/common/style.dart';
import 'package:submission_resto/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restoran Nusantara',
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.yellow,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.yellow,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
      },
    );
  }
}
