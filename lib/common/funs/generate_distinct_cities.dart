List<String> generateDistinctCities(restaurants) {
  var citySet = <String>{};
  for (var c in restaurants) {
    citySet.add(c.city);
  }

  List<String> cityList = [];
  cityList = citySet.toList();
  cityList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  cityList.insert(0, 'Semua');

  return cityList;
}
