import 'package:submission_resto/data/model/restaurants_model.dart';

class LocalRestaurantModel {
  List<Restaurants>? restaurants;

  LocalRestaurantModel({this.restaurants});

  LocalRestaurantModel.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      restaurants = json['restaurants']
          .map<Restaurants>((resto) => Restaurants.fromJson(resto))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
