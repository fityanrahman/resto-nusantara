import 'package:flutter/material.dart';
import 'package:submission_resto/common/funs/generate_distinct_cities.dart';
import 'package:submission_resto/data/model/local_restaurant_model.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(body: _buildListRestoFav(context));
  }

  FutureBuilder<String> _buildListRestoFav(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/local_restaurant.json'),
      builder: (context, snapshot) {
        final List<Restaurants> restaurants = parseRestaurant(snapshot.data);

        // generate specific city restaurants
        List<Restaurants> cityRestaurants = restaurants;
        if (city == '') {
          cityRestaurants = restaurants;
        } else {
          cityRestaurants =
              restaurants.where((element) => element.city == city).toList();
          //sort restaurant by rating
          cityRestaurants.sort((a, b) => b.rating!.compareTo(a.rating!));
        }

        //get distinct cities list
        final cities = generateDistinctCities(restaurants);

        return ListView(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.only(left: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        city = cities[index];
                        print('selectedCity = $city');
                      });
                    },
                    child: CircleKotaWidget(
                      city: cities[index],
                    ),
                  );
                },
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
                    child: FavRestoWidget(
                      restaurants: cityRestaurants[index],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
