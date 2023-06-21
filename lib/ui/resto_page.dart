import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_overlay/shadow_overlay.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_detail_model.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/provider/order_provider.dart';
import 'package:submission_resto/ui/cart_page.dart';
import 'package:submission_resto/widget/add_to_cart_button.dart';
import 'package:submission_resto/widget/item_resto_widget.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = '/resto-page';
  final String idResto;

  const RestaurantPage({required this.idResto, Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<Order> transaksi = [];
  var idSet = <String>{};
  var distinct = <Order>[];

  bool fav = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dataProvider = Provider.of<OrderProvider>(context, listen: false);
      dataProvider.fetchDetailRestaurant(id: widget.idResto);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderPvdr = Provider.of<OrderProvider>(context);

    final textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = getCurrentColorScheme(context);
    return Scaffold(
      body: orderPvdr.state == ResultState.loading
          ? Center(child: CircularProgressIndicator())
          : NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, isScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ShadowOverlay(
                        shadowWidth: 800,
                        shadowHeight: 200,
                        shadowColor: colorScheme.surface,
                        child: Hero(
                          tag:
                              "$baseUrl$imgRestoMedium${orderPvdr.restaurantDetail.restaurant.pictureId}",
                          child: Image.network(
                            "$baseUrl$imgRestoMedium${orderPvdr.restaurantDetail.restaurant.pictureId}",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, _) => const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      centerTitle: true,
                      title: Text(
                        orderPvdr.restaurantDetail.restaurant.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            fav = !fav;
                          });
                        },
                        icon: fav ? Icon(Icons.star) : Icon(Icons.star_outline),
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
                      _ratingLocResto(
                          textTheme,
                          orderPvdr.restaurantDetail.restaurant.rating,
                          orderPvdr.restaurantDetail.restaurant.city),
                      _detailResto(textTheme,
                          orderPvdr.restaurantDetail.restaurant.description),
                      _itemRestoWidget(
                        textTheme,
                        orderPvdr.restaurantDetail.restaurant.menus.foods,
                        'Makanan',
                        true,
                      ),
                      _itemRestoWidget(
                        textTheme,
                        orderPvdr.restaurantDetail.restaurant.menus.drinks,
                        'Minuman',
                        false,
                      ),
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
            Navigator.pushNamed(
              context,
              CartPage.routeName,
              arguments: distinct,
            );
          },
        ),
      ),
    );
  }

  Widget _detailResto(TextTheme textTheme, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 28.0, bottom: 16.0),
            child: Text(
              'Detail Restoran',
              style: textTheme.titleMedium,
            ),
          ),
          ExpandableText(
            description,
            maxLines: 3,
            expandText: 'tampilkan lebih banyak',
            collapseText: 'tampilkan lebih sedikit',
            textAlign: TextAlign.justify,
            animation: true,
          ),
        ],
      ),
    );
  }

  Widget _ratingLocResto(TextTheme textTheme, double rating, String location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(rating.toString()),
                ],
              ),
              SizedBox(width: 16),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(location.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemRestoWidget(
      TextTheme textTheme, List<Category>? food, String type, bool isFood) {
    List<Order> order = [];

    //buat list of Order
    for (int i = 0; i < food!.length; i++) {
      order.add(
        Order(
          id: '$type${i + 1}',
          name: food[i].name,
          qty: 0,
          fav: false,
          price: 12000,
          food: isFood,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: textTheme.titleMedium,
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
    //tambahkan item ke list transaksi
    transaksi.add(order);

    //buat set of string idSet. kemudian tambah item ke dalam list distinct berdasarkan idSet
    for (var d in transaksi) {
      if (idSet.add(d.id)) {
        distinct.add(d);
      }
    }

    //hapus item dengan qty < 1 dari list distinct
    for (int i = 0; i < distinct.length; i++) {
      if (distinct[i].qty < 1) {
        idSet.remove(distinct[i].id);
        distinct.remove(distinct[i]);
      }
    }

    //hapus list transaksi
    transaksi.clear();
  }
}
