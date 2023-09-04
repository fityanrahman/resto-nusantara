import 'package:equatable/equatable.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class ListRestaurant extends Equatable {
  final bool error;
  final String message;
  final int count;
  final List<RestaurantsShort> restaurants;

  const ListRestaurant({
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

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson()))
      };

  //untuk memudahkan debug (print/log)
  @override
  String toString() {
    return 'ListRestaurant{error: $error,message: $message, count: $count, restaurants: $restaurants}';
  }

  @override
  List<Object> get props => [error, message, count, restaurants];
}
