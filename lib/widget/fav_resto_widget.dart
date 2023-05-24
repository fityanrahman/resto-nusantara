import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';

class FavRestoWidget extends StatelessWidget {
  final Restaurants restaurants;

  const FavRestoWidget({
    required this.restaurants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 280,
      padding: const EdgeInsets.all(24),
      alignment: Alignment.bottomLeft,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        // color: Colors.grey,
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
        image: DecorationImage(
          image: NetworkImage(
              restaurants.pictureId!),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(restaurants.name!),
          Text(restaurants.city!),
          Row(
            children: [
              const Icon(Icons.star),
              Text(restaurants.rating!),
            ],
          )
        ],
      ),
    );
  }
}
