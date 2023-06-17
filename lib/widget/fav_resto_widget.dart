import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class FavRestoWidget extends StatelessWidget {
  final RestaurantsShort restaurants;

  const FavRestoWidget({
    required this.restaurants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getCurrentColorScheme(context);
    final textTheme = Theme.of(context).textTheme;
    final image = "$baseUrl$imgRestoMedium/${restaurants.pictureId}";

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        height: 280,
        alignment: Alignment.bottomLeft,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        child: Stack(
          children: [
            Hero(
              tag: image,
              child: Image.network(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, _) => const Center(
                  child: Icon(Icons.error),
                ),
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
      ),
    );
  }
}
