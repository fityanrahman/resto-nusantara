import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/foods_model.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/ui/cart_page.dart';
import 'package:submission_resto/widget/add_to_cart_button.dart';

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

  // Map<String, int> _finalSummary = {};
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
                // titlePadding: EdgeInsets.zero,
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
                const Text(
                  'Detail Restaurant',
                ),
                Text(
                  widget.restaurants.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  'Makanan',
                ),
                _itemRestoWidget(
                    textTheme, widget.restaurants.menus!.foods, 'food'),
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  'Minuman',
                ),
                _itemRestoWidget(
                    textTheme, widget.restaurants.menus!.drinks, 'drink'),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 72,
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
      ),
    );
  }

  Widget _itemRestoWidget(TextTheme textTheme, List<Foods>? food, String type) {
    List<Order> order = [];

    for (int i = 0; i < food!.length; i++) {
      order.add(Order(
          id: '$type${i + 1}',
          name: food[i].name!,
          qty: 0,
          fav: false,
          price: 12000));
    }

    return ListView.builder(
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
    );
  }

  //callback for add order function
  void _tambahTransaksi(Order order) {
    hitungItem = [];
    _itemHitung = 0;

    subTotal = [];
    _itemHarga = 0;

    transaksi.add(order);

    print('jumlah transaksi = ${transaksi.length}');

    for (var d in transaksi) {
      if (idSet.add(d.id)) {
        distinct.add(d);
      }
    }

    transaksi.clear();

    print('jumlah transaksi 2 = ${transaksi.length}');
    print('menu unik = ${distinct.length}');

    for (var d in distinct) {
      hitungItem.add(d.qty);
    }

    for (int e in hitungItem) {
      _itemHitung += e;
    }

    print('jumlah pesanan: $_itemHitung');

    for (var j in distinct) {
      subTotal.add(j.qty * j.price);
    }

    for (int j in subTotal) {
      _itemHarga += j;
    }

    print('total pesanan: $_itemHarga');

    //   Map<String, int> summary = {
    //     'itemCount': jmlItem,
    //     'amount': grandTotal,
    //   };
    //
    // var mapKeys = summary.keys; //get all keys
    // var mapValues = summary.values; //get all values
    // print(mapKeys);
    // print(mapValues);

    // setState(() {
    //   _itemHitung = jmlItem;
    //   _itemHarga = grandTotal;
    // });
  }
}

class ItemRestoWidget extends StatefulWidget {
  final TextTheme textTheme;
  final Order order;
  final Function tambahTransaksi;

  const ItemRestoWidget({
    required this.textTheme,
    required this.order,
    required this.tambahTransaksi,
    Key? key,
  }) : super(key: key);

  @override
  State<ItemRestoWidget> createState() => _ItemRestoWidgetState();
}

class _ItemRestoWidgetState extends State<ItemRestoWidget> {
  List<Order> transaction = [];
  List<int> itemCounts = [];

  var idSet = <int>{};
  var distinct = <Order>[];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title: Text(widget.order.name),
            subtitle: Text('Rp ${widget.order.price.toString()}'),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: widget.order.qty == 0 ? 16 : 0, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.order.qty == 0
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.order.qty++;
                            _addTransaction(widget.order);
                          });
                        },
                        child: Text(
                          'Tambah',
                          style: widget.textTheme.labelSmall,
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
                                widget.order.qty--;
                                _addTransaction(widget.order);
                              });
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(widget.order.qty.toString()),
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
                                widget.order.qty++;
                                _addTransaction(widget.order);
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
                      widget.order.fav = !widget.order.fav;
                    });
                  },
                  icon: Icon(
                    widget.order.fav ? Icons.star : Icons.star_outline,
                    color: Colors.orangeAccent,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //add order function
  void _addTransaction(Order order) {
    transaction.add(order);
    widget.tambahTransaksi(order);
    // countTransaction(distinct);
  }
}
