import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/local_restaurant_model.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';
import 'package:submission_resto/widget/circle_kota_widget.dart';
import 'package:submission_resto/widget/fav_resto_widget.dart';
import 'package:submission_resto/widget/list_resto_widget.dart';
import 'package:submission_resto/widget/search_anchors_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home-page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        children: [
          Text('Restoran Favorit di Medan'),
          SizedBox(height: 16),
          Container(
            height: 280,
            child: _buildListRestoFav(context),
          ),
        ],
      ),
    );
  }

  FutureBuilder<String> _buildListRestoFav(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/local_restaurant.json'),
      builder: (context, snapshot) {
        final List<Restaurants> restaurants = parseRestaurant(snapshot.data);

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(width: 24),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return FavRestoWidget(
              restaurants: restaurants[index],
            );
          },
        );
      },
    );
  }
}
