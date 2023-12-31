import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/generate_distinct_cities.dart';
import 'package:submission_resto/common/utils/notification_helper.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';
import 'package:submission_resto/provider/home_provider.dart';
import 'package:submission_resto/ui/favorite_page.dart';
import 'package:submission_resto/ui/resto_page.dart';
import 'package:submission_resto/ui/setting_page.dart';
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
  final NotificationHelper _notificationHelper = NotificationHelper();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantPage.routeName);
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        homeProvider.isExtendedFAB = false;
      } else {
        homeProvider.isExtendedFAB = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildListRestoFav(context),
      floatingActionButton: _favRestoFAB(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _favRestoFAB() {
    return Consumer<HomeProvider>(
      builder: (context, state, _) {
        return state.state == ResultState.hasData
            ? state.isExtendedFAB
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return AnimatedContainer(
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 250),
                          child: child);
                    },
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pushNamed(context, FavoritePage.routeName);
                      },
                      key: ValueKey<bool>(state.isExtendedFAB),
                      icon: const Icon(Icons.star),
                      label: const Text('Favorit'),
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return AnimatedContainer(
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 250),
                          child: child);
                    },
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, FavoritePage.routeName);
                      },
                      key: ValueKey<bool>(state.isExtendedFAB),
                      child: const Icon(Icons.star),
                    ),
                  )
            : const SizedBox();
      },
    );
  }

  Widget _buildListRestoFav(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    List<RestaurantsShort> restaurants = [];
    List<RestaurantsShort> cityRestaurants = [];
    late List<String> cities;

    return Consumer<HomeProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (state.state == ResultState.hasData) {
            restaurants = state.restaurants;

            // generate specific city restaurants
            cityRestaurants = restaurants;

            //handle data on specific city
            if (state.city == 'Nusantara') {
              cityRestaurants = restaurants;
            } else {
              cityRestaurants = restaurants
                  .where((element) => element.city == state.city)
                  .toList();
              //sort restaurant by rating
              cityRestaurants.sort((a, b) => b.rating!.compareTo(a.rating!));
            }

            //get distinct cities list
            cities = generateDistinctCities(restaurants);
          } else if (state.state == ResultState.networkError) {
            return Center(
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.network_check),
                    Text(state.message),
                    TextButton(
                      onPressed: () async {
                        state.fetchAllRestaurant();
                      },
                      child: const Text('Refresh'),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning),
                    Text(state.message),
                    TextButton(
                      onPressed: () async {
                        state.fetchAllRestaurant();
                      },
                      child: const Text('Refresh'),
                    )
                  ],
                ),
              ),
            );
          }
        }

        return ListView(
          controller: _scrollController,
          children: [
            _searchSettingBar(),
            _listKota(cities, textTheme, homeProvider),
            _listFavResto(cityRestaurants, textTheme),
            _listRestoNusa(restaurants, textTheme)
          ],
        );
      },
    );
  }

  Widget _searchSettingBar() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        const Expanded(child: SearchAnchors()),
        IconButton(
          iconSize: 8,
          padding: const EdgeInsets.only(right: 16),
          onPressed: () {
            Navigator.pushNamed(context, SettingsPage.routeName);
          },
          icon: const Icon(
            Icons.settings,
            size: 24,
          ),
        )
      ],
    );
  }

  Widget _listRestoNusa(
      List<RestaurantsShort> restaurants, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 16, left: 16.0),
          child: Text(
            'Restoran Nusantara',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 0.0,
                bottom: index == restaurants.length - 1 ? 16 : 0,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RestaurantPage.routeName,
                      arguments: restaurants[index]);
                },
                child: ListRestoWidget(
                  restaurants: restaurants[index],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _listFavResto(
      List<RestaurantsShort> cityRestaurants, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 16, left: 16.0),
          child: Consumer<HomeProvider>(builder: (context, state, _) {
            return Text(
              'Restoran Favorit di ${state.city}',
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            );
          }),
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 24),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: cityRestaurants.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 0,
                  right: index == cityRestaurants.length - 1 ? 16 : 0,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RestaurantPage.routeName,
                        arguments: cityRestaurants[index]);
                  },
                  child: FavRestoWidget(
                    restaurants: cityRestaurants[index],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _listKota(
      List<String> cities, TextTheme textTheme, HomeProvider homeProvider) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 0,
              right: index == cities.length - 1 ? 16 : 0,
            ),
            child: InkWell(
              onTap: () {
                homeProvider.city = cities[index];
              },
              child: CircleKotaWidget(
                city: cities[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
