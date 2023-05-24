import 'package:flutter/foundation.dart';

void generateDistinctCities(restaurants) {
  var citySet = <String?>{};
  for (var c in restaurants) {
    citySet.add(c.city);
  }

  if (kDebugMode) {
    print('citySet = $citySet');
  }

  var cityList = [];
  cityList = citySet.toList();
  if (kDebugMode) {
    print('cityList = $cityList');
  }
}