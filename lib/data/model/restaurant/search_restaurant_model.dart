import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class SearchRestaurant {
  bool error;
  int founded;
  List<RestaurantsShort> restaurantsShort;

  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurantsShort,
  });

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) =>
      SearchRestaurant(
        error: json["error"],
        founded: json["founded"],
        restaurantsShort: List<RestaurantsShort>.from(
            json["restaurants"].map((x) => RestaurantsShort.fromJson(x))),
      );
}
