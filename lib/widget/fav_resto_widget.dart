import 'package:flutter/material.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';

class FavRestoWidget extends StatelessWidget {
  final Restaurants restaurants;

  const FavRestoWidget({
    required this.restaurants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getCurrentColorScheme(context);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        height: 280,
        // padding: const EdgeInsets.all(24),
        alignment: Alignment.bottomLeft,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          // color: Colors.grey,
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
          image: DecorationImage(
            image: NetworkImage(restaurants.pictureId!),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.secondaryContainer,
                      Colors.transparent,
                      Colors.transparent,
                      colorScheme.secondaryContainer,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0, 0.1, 1],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(restaurants.name!, style: TextStyle(color: colorScheme.onSecondaryContainer),),
                  Text(restaurants.city!),
                  Row(
                    children: [
                      const Icon(Icons.star),
                      Text(restaurants.rating.toString()),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
