import 'package:flutter/material.dart';
import 'package:submission_resto/ui/cart_page.dart';
import 'package:submission_resto/widget/add_to_cart_button.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/resto-page';

  const RestaurantPage({Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  var menu = 0;
  var fav = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 280,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://restaurant-api.dicoding.dev/images/medium/14',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, _) =>
                      const Center(child: Icon(Icons.error)),
                ),
                centerTitle: true,
                // titlePadding: EdgeInsets.zero,
                title: const Text('Tempat Siang Hari'),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star_outline),
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Restaurant',
                ),
                Text(
                  'Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus.  Maecenas tempusMaecenas tempusMaecenas tempusMaecenas tempus',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 28,
                ),
                Text(
                  'Makanan',
                ),
                _itemRestoWidget(textTheme),
                SizedBox(
                  height: 28,
                ),
                Text(
                  'Minuman',
                ),
                _itemRestoWidget(textTheme),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
            height: 72,
            child: AddToCartButton(
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
              },
            )),
      ),
    );
  }

  Widget _itemRestoWidget(TextTheme textTheme) {
    return Column(
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
              Padding(
                padding: EdgeInsets.only(left: menu == 0 ? 16 : 0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    menu == 0
                        ? ElevatedButton(
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
                          )
                        : Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  minimumSize: Size.zero,
                                  fixedSize: const Size(24, 24),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  setState(() {
                                    menu--;
                                    print('menu : $menu');
                                  });
                                },
                                child: const Icon(
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
                                  shape: const CircleBorder(),
                                  minimumSize: Size.zero,
                                  fixedSize: const Size(24, 24),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  setState(() {
                                    menu++;
                                    print('menu : $menu');
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          fav = !fav;
                          print(fav);
                        });
                      },
                      icon: Icon(
                        fav ? Icons.star : Icons.star_outline,
                        color: Colors.orangeAccent,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
