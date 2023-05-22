import 'package:flutter/material.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/resto-page';

  const RestaurantPage({Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  var menu = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Color(0xffd9d9d9),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Image.network(
                          'https://restaurant-api.dicoding.dev/images/medium/14',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, _) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      ),
                      title: const Text('Kari kacang dan telur'),
                      subtitle: const Text('Rp 10.000'),
                    ),
                    menu == 0
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  menu++;
                                  print('menu : $menu');
                                });
                              },
                              child: Text(
                                'Tambah',
                                style: textTheme.labelSmall,
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  minimumSize: Size.zero,
                                  fixedSize: Size(24, 24),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  setState(() {
                                    menu--;
                                    print('menu : $menu');
                                  });
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 16,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(menu.toString()),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  minimumSize: Size.zero,
                                  fixedSize: Size(24, 24),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  setState(() {
                                    menu++;
                                    print('menu : $menu');
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
