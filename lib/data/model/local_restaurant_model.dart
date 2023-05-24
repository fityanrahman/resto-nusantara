import 'dart:convert';

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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurants != null) {
      data['restaurants'] = restaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

List<Restaurants> parseRestaurant(String? json) {
  if (json == null) {
    return [];
  }

  final List parsed = jsonDecode(json);
  // print('json = $json');
  return parsed.map((e) => Restaurants.fromJson(e)).toList();
}