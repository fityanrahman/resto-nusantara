import 'package:flutter/foundation.dart';

List<String> generateDistinctCities(restaurants) {
  var citySet = <String>{};
  for (var c in restaurants) {
    citySet.add(c.city);
  }

  if (kDebugMode) {
    print('citySet = $citySet');
  }

  List<String>cityList = [];
  cityList = citySet.toList();
  if (kDebugMode) {
    print('cityList = $cityList');
  }
  cityList.insert(0, 'Semua');

  return cityList;
}