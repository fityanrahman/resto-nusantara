import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_overlay/shadow_overlay.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
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
  @override
  void initState() {
    super.initState();
    final dataProvider = Provider.of<OrderProvider>(context, listen: false);
    dataProvider.fetchDetailRestaurant(id: widget.idResto);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = getCurrentColorScheme(context);

    return Scaffold(
      body: Consumer<OrderProvider>(builder: (context, state, _) {
        switch (state.state) {
          case ResultState.loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ResultState.hasData:
            return NestedScrollView(
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
                              "$baseUrl$imgRestoMedium${state.restaurantDetail.restaurant.pictureId}",
                          child: Image.network(
                            "$baseUrl$imgRestoMedium${state.restaurantDetail.restaurant.pictureId}",
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
                        state.restaurantDetail.restaurant.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          state.fav = !state.fav;
                        },
                        icon: state.fav
                            ? Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                            : Icon(Icons.star_outline),
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
                        state.restaurantDetail.restaurant.rating,
                        state.restaurantDetail.restaurant.city,
                      ),
                      _detailResto(
                        textTheme,
                        state.restaurantDetail.restaurant.description,
                      ),
                      _itemRestoWidget(
                        textTheme,
                        state.orderFood,
                        'Makanan',
                        true,
                      ),
                      _itemRestoWidget(
                        textTheme,
                        state.orderDrink,
                        'Minuman',
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            );
          case ResultState.networkError:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.network_check),
                  Text(state.message),
                  TextButton(
                    onPressed: () {
                      state.fetchDetailRestaurant(id: widget.idResto);
                    },
                    child: Text('Refresh'),
                  )
                ],
              ),
            );
          case ResultState.timeoutError:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_off),
                  Text(state.message),
                ],
              ),
            );
          default:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning),
                  Text(state.message),
                  TextButton(
                    onPressed: () {
                      state.fetchDetailRestaurant(id: widget.idResto);
                    },
                    child: Text('Refresh'),
                  )
                ],
              ),
            );
        }
      }),
      extendBody: true,
      bottomNavigationBar: _lanjutBayar(context),
    );
  }

  Widget _lanjutBayar(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, order, _) {
      return order.distinct.length >= 1
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 60,
                child: AddToCartButton(
                  onPress: () {
                    Navigator.pushNamed(
                      context,
                      CartPage.routeName,
                      arguments: order.distinct,
                    );
                  },
                  restoName: order.restaurantDetail.restaurant.name,
                  itemCount: order.itemCount,
                  amount: order.amount,
                ),
              ),
            )
          : SizedBox();
    });
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
      TextTheme textTheme, List<Order> food, String type, bool isFood) {
    final order = Provider.of<OrderProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: textTheme.titleMedium,
          ),
          SizedBox(
            height: 8,
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: food.length,
            itemBuilder: (context, index) {
              return ItemRestoWidget(
                textTheme: textTheme,
                order: food[index],
                tambahTransaksi: order.tambahTransaksi,
              );
            },
          ),
        ],
      ),
    );
  }
}
