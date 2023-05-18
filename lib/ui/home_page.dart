import 'package:flutter/material.dart';

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
            Container(
              height: 280,
              width: 280,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomLeft,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tempat Siang Hari'),
                  Text('Surabaya'),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Text('4.4'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
