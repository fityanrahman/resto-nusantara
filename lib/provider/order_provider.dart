import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_detail_model.dart';

class OrderProvider extends ChangeNotifier {
  final apiService = ApiService();

  late RestaurantDetail _restaurantDetail;
  ResultState _state = ResultState.loading;
  String _message = '';

  RestaurantDetail get restaurantDetail => _restaurantDetail;

  ResultState get state => _state;

  String get message => _message;

  Future<dynamic> fetchDetailRestaurant({required String id}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await apiService.getDetailRestaurant(id: id);

      _state = ResultState.hasData;
      notifyListeners();
      return _restaurantDetail = restaurant;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = '${e.toString()} / $id';
    }
  }
}
