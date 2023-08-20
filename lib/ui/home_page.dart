import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/generate_distinct_cities.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';
import 'package:submission_resto/provider/home_provider.dart';
import 'package:submission_resto/ui/resto_page.dart';
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
    return Scaffold(
      body: _buildListRestoFav(context),
    );
  }

  Widget _buildListRestoFav(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    List<RestaurantsShort> restaurants = [];
    List<RestaurantsShort> cityRestaurants = [];
    late var cities;

    return Consumer<HomeProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return Center(
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
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.error) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else {
            return Center(
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.network_check),
                    Text(state.message),
                    TextButton(
                      onPressed: () async {
                        // state.fetchDetailRestaurant(id: widget.idResto);
                        state.fetchAllRestaurant();
                      },
                      child: Text('Refresh'),
                    )
                  ],
                ),
              ),
            );
          }
        }

        return ListView(
          children: [
            SearchAnchors(restaurants: restaurants),
            _listKota(cities, textTheme, homeProvider),
            _listFavResto(cityRestaurants, textTheme),
            _listRestoNusa(restaurants, textTheme)
          ],
        );
      },
    );
  }

  Widget _listRestoNusa(
      List<RestaurantsShort> restaurants, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 28, bottom: 16, left: 16.0),
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
                      arguments: restaurants[index].id);
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
                        arguments: cityRestaurants[index].id);
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
                setState(() {
                  homeProvider.city = cities[index];
                });
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
