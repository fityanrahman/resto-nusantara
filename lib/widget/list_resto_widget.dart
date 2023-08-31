import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class ListRestoWidget extends StatelessWidget {
  final RestaurantsShort restaurants;

  const ListRestoWidget({
    required this.restaurants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getCurrentColorScheme(context);
    final textTheme = Theme.of(context).textTheme;
    final image = "$baseUrl$imgRestoSmall/${restaurants.pictureId}";

    return Container(
      width: double.infinity,
      height: 100,
      alignment: Alignment.bottomLeft,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          Image.network(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, _) => const Center(
              child: Icon(Icons.error),
            ),
          ),
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
                const SizedBox(height: 2),
                Text(restaurants.city!),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
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
