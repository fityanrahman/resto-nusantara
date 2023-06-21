import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService apiService;

  HomeProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  List<RestaurantsShort> _restaurants = [];
  List<RestaurantsShort> _cityRestaurants = [];
  late ResultState _state;
  String _message = '';
  String _city = '';

  List<RestaurantsShort> get restaurants => _restaurants;
  List<RestaurantsShort> get cityRestaurants => _cityRestaurants;
  ResultState get state => _state;
  String get message => _message;
  String get city => _city;

  set city(String city) {
    _city = city;
    notifyListeners();
  }

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.getListRestaurants();
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data Kosong';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurants = restaurants.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = e.toString();
    }
  }
}
