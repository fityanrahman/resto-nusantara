import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/foods_model.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/ui/cart_page.dart';
import 'package:submission_resto/widget/add_to_cart_button.dart';
import 'package:submission_resto/widget/item_resto_widget.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/resto-page';

  final Restaurants restaurants;

  const RestaurantPage({required this.restaurants, Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<Order> transaksi = [];
  var idSet = <String>{};
  var distinct = <Order>[];

  List<int> subTotal = [];
  List<int> hitungItem = [];
  int _itemHitung = 0;
  int _itemHarga = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 280,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  widget.restaurants.pictureId!,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, _) =>
                      const Center(child: Icon(Icons.error)),
                ),
                centerTitle: true,
                title: Text(widget.restaurants.name!),
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
                _detailResto(),
                _itemRestoWidget(
                    textTheme, widget.restaurants.menus!.foods, 'Makanan'),
                _itemRestoWidget(
                    textTheme, widget.restaurants.menus!.drinks, 'Minuman'),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _lanjutBayar(context),
    );
  }

  Widget _lanjutBayar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 60,
        child: AddToCartButton(
          onPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartPage()));
          },
          itemCount: _itemHitung,
          amount: _itemHarga,
          restoName: widget.restaurants.name!,
        ),
      ),
    );
  }

  Widget _detailResto() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        children: [
          const Text(
            'Detail Restaurant',
          ),
          const SizedBox(height: 16),
          Text(
            widget.restaurants.description!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _itemRestoWidget(TextTheme textTheme, List<Foods>? food, String type) {
    List<Order> order = [];

    for (int i = 0; i < food!.length; i++) {
      order.add(
        Order(
            id: '$type${i + 1}',
            name: food[i].name!,
            qty: 0,
            fav: false,
            price: 12000),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.length,
            itemBuilder: (context, index) {
              return ItemRestoWidget(
                textTheme: textTheme,
                order: order[index],
                tambahTransaksi: _tambahTransaksi,
              );
            },
          ),
        ],
      ),
    );
  }

  //callback for add order function
  void _tambahTransaksi(Order order) {
    hitungItem = [];
    _itemHitung = 0;

    subTotal = [];
    _itemHarga = 0;

    transaksi.add(order);

    for (var d in transaksi) {
      if (idSet.add(d.id)) {
        distinct.add(d);
      }
    }

    transaksi.clear();

    for (var d in distinct) {
      hitungItem.add(d.qty);
    }

    for (int e in hitungItem) {
      _itemHitung += e;
    }

    for (var j in distinct) {
      subTotal.add(j.qty * j.price);
    }

    for (int j in subTotal) {
      _itemHarga += j;
    }
  }
}
