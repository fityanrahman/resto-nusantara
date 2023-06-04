import 'package:flutter/material.dart';
import 'package:submission_resto/common/funs/generate_distinct_cities.dart';
import 'package:submission_resto/data/model/local_restaurant_model.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';
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
  var city = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildListRestoFav(context),
    );
  }

  FutureBuilder<String> _buildListRestoFav(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/local_restaurant.json'),
      builder: (context, snapshot) {
        final List<Restaurants> restaurants = parseRestaurant(snapshot.data);

        // generate specific city restaurants
        List<Restaurants> cityRestaurants = restaurants;

        //handle data on specific city
        switch (city) {
          case '':
            cityRestaurants = restaurants;
            break;
          case 'Semua':
            cityRestaurants = restaurants;
            city = 'Nusantara';
            break;
          case 'Nusantara':
            cityRestaurants = restaurants;
            break;
          default:
            cityRestaurants =
                restaurants.where((element) => element.city == city).toList();
            //sort restaurant by rating
            cityRestaurants.sort((a, b) => b.rating!.compareTo(a.rating!));
        }

        //get distinct cities list
        final cities = generateDistinctCities(restaurants);

        return ListView(
          children: [
            SearchAnchors(restaurants: restaurants),
            _listKota(cities, textTheme),
            _listFavResto(cityRestaurants, textTheme),
            _listRestoNusa(restaurants, textTheme)
          ],
        );
      },
    );
  }

  Widget _listRestoNusa(List<Restaurants> restaurants, TextTheme textTheme) {
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

  Widget _listFavResto(List<Restaurants> cityRestaurants, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 16, left: 16.0),
          child: Text(
            'Restoran Favorit di ${city == '' ? 'Nusantara' : city}',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
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

  Widget _listKota(List<String> cities, TextTheme textTheme) {
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
                  city = cities[index];
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
