import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/custom_exception.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService apiService;

  HomeProvider({required this.apiService}) {
    fetchAllRestaurant();
  }

  List<RestaurantsShort> _restaurants = [];
  List<RestaurantsShort> _cityRestaurants = [];
  late ResultState _state;
  String _message = '';
  String _city = 'Nusantara';
  bool _isExtendedFAB = true;

  List<RestaurantsShort> get restaurants => _restaurants;

  List<RestaurantsShort> get cityRestaurants => _cityRestaurants;

  ResultState get state => _state;

  String get message => _message;

  String get city => _city;
  set city(String city) {
    if (city == 'Semua') {
      _city = 'Nusantara';
    } else {
      _city = city;
    }
    notifyListeners();
  }

  bool get isExtendedFAB => _isExtendedFAB;
  set isExtendedFAB(bool isExtendedFAB) {
    _isExtendedFAB = isExtendedFAB;
    notifyListeners();
  }

  Future<dynamic> fetchAllRestaurant() async {
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
    } on SocketException catch (e) {
      _state = ResultState.networkError;
      _message = e.message;
      notifyListeners();
      return _message;
    } on TimeoutException catch (e) {
      _state = ResultState.timeoutError;
      _message = e.message!;
      notifyListeners();
      return _message;
    } on CustomException catch (e) {
      _state = e.state;
      _message = e.message;
      notifyListeners();
      return _message;
    }
  }
}
