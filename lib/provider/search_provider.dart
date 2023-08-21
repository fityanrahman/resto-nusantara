import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/custom_exception.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';
import 'package:submission_resto/data/model/restaurant/search_restaurant_model.dart';

class SearchProvider extends ChangeNotifier {
  ResultState _state = ResultState.loading;
  String _message = '';

  List<RestaurantsShort> _searchList = [];

  String get message => _message;
  List<RestaurantsShort> get searchList => _searchList;
  ResultState get state => _state;

  Future<dynamic> searchRestaurant({required String query}) async {
    try {
      if (_state != ResultState.loading) {
        _state = ResultState.loading;
        _message = 'Memuat pencarian data';
        notifyListeners();
      }

      _searchList.clear();

      final SearchRestaurant restaurants =
          await ApiService().searchRestaurant(query: query);

      if (restaurants.restaurantsShort.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data tidak ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchList = restaurants.restaurantsShort;
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