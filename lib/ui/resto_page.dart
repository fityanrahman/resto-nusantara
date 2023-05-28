import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/foods_model.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/ui/cart_page.dart';
import 'package:submission_resto/widget/add_to_cart_button.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/resto-page';

  final Restaurants restaurants;

  RestaurantPage({required this.restaurants, Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

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
                _itemRestoWidget(textTheme, widget.restaurants.menus!.foods),
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  'Minuman',
                ),
                _itemRestoWidget(textTheme, widget.restaurants.menus!.drinks),
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
            )),
      ),
    );
  }

  Widget _itemRestoWidget(TextTheme textTheme, List<Foods>? food) {
    List<Order> order = [];

    for (int i = 0; i < food!.length; i++) {
      order.add(Order(id: i+1, name: food[i].name!, qty: 0, fav: false, price: 12000));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: order.length,
      itemBuilder: (context, index) {
        return ItemRestoWidget(textTheme: textTheme, order: order[index]);
      },
    );
  }
}

class ItemRestoWidget extends StatefulWidget {
  final TextTheme textTheme;
  Order order;

  ItemRestoWidget({
    required this.textTheme,
    required this.order,
    Key? key,
  }) : super(key: key);

  @override
  State<ItemRestoWidget> createState() => _ItemRestoWidgetState();
}

class _ItemRestoWidgetState extends State<ItemRestoWidget> {
  // int itemQty = 0;
  // bool itemFav = false;

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
                                // itemQty = widget.order.qty;
                                // itemQty++;
                                _addTransaction(widget.order);
                                // print('menu widget : ${widget.order.qty}');
                                // print('menu state : $itemQty');
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
                                    // itemQty = widget.order.qty;
                                    // itemQty--;
                                    _addTransaction(widget.order);
                                    // print('menu widget : ${widget.order.qty}');
                                    // print('menu state : $itemQty');
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
                                // child: Text(itemQty.toString()),
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
                                    // itemQty = widget.order.qty;
                                    // itemQty++;
                                    _addTransaction(widget.order);
                                    // print('menu widget : ${widget.order.qty}');
                                    // print('menu state : $itemQty');
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
                          // itemFav = widget.order.fav;
                          print('fav widget : ${widget.order.fav}');
                          // print('fav state : $itemFav');
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

  //add transaction was here
  void _addTransaction(Order order) {
    // List<Order> transaction = [];
    // List<int> itemCount = [];

    transaction.add(order);

    // var idSet = <int>{};
    // var distinct = <Order>[];
    for (var d in transaction) {
      if (idSet.add(d.id)) {
        distinct.add(d);
      }
    }

    print('last id = ${distinct.last.id}');
    print('distinct =  ${distinct.length}');

    // if (order.qty < 1) {
    //   transaction.remove(order);
    //   print('remove $order');
    // }


    // for (int i = 0; i < transaction.length; i++) {
    //   itemCount.add(transaction[i].qty);
    // }

    for (var a in distinct) {
      itemCounts.add(a.qty);
    }

    print('transactions = ${distinct.toList().toString()}');

    // itemCount.add(order.qty);
    //
    print('itemCount = $itemCounts');

    print('tambah name order ${order.name}');
    print('tambah qty order ${order.qty}');
    print('tambah order ${transaction.length}');
    countTransaction(distinct);
  }
}

Map<String, dynamic> countTransaction(List<Order> transaction) {
  int count;
  int sum = 0;
  var listSum = [];
  Map<String, int> summary;

  count = transaction.length;

  for (int i = 0; i < transaction.length; i++) {
    listSum.add(transaction[i].qty * transaction[i].price);
  }

  // int sums => listSum.fold(0, (e, t) => e + t);

  for (int e in listSum) {
    sum += e;
  }

  summary = {
    'count': count,
    'sum': sum,
  };

  print('hitung transaksi $summary');

  return summary;
}
