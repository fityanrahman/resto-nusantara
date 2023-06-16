import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class ListRestaurant {
  bool error;
  String message;
  int count;
  List<RestaurantsShort> restaurants;

  ListRestaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory ListRestaurant.fromJson(Map<String, dynamic> json) => ListRestaurant(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<RestaurantsShort>.from(
            json["restaurants"].map((x) => RestaurantsShort.fromJson(x))),
      );
}
