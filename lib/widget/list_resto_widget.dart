import 'package:flutter/material.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/restaurants_model.dart';

class ListRestoWidget extends StatelessWidget {
  final Restaurants restaurants;

  const ListRestoWidget({
    required this.restaurants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getCurrentColorScheme(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: 100,
      alignment: Alignment.bottomLeft,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
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
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  stops: const [0, 0, 0.1, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurants.name!,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(restaurants.city!),
                SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(restaurants.rating.toString()),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
