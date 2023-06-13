import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class SearchRestaurant {
  bool error;
  int founded;
  RestaurantsShort restaurantsShort;

  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurantsShort,
  });

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) =>
      SearchRestaurant(
        error: json["error"],
        founded: json["founded"],
        restaurantsShort: RestaurantsShort.fromJson(json["restaurants"]),
      );
}
