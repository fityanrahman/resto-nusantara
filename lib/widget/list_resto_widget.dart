import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';

class ListRestoWidget extends StatelessWidget {
  final Restaurants restaurants;

  const ListRestoWidget({
    required this.restaurants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        // color: Colors.grey,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
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
              Text(restaurants.rating.toString()),
            ],
          )
        ],
      ),
    );
  }
}
