import 'package:flutter/material.dart';
import 'package:submission_resto/widget/circle_kota_widget.dart';
import 'package:submission_resto/widget/fav_resto_widget.dart';
import 'package:submission_resto/widget/list_resto_widget.dart';
import 'package:submission_resto/widget/search_anchors_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchAnchors(),
            ],
          ),
        ),
      ),
    );
  }
}
