import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/custom_exception.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_detail_model.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';

class OrderProvider extends ChangeNotifier {
  ResultState _state = ResultState.loading;
  String _message = '';

  late RestaurantDetail _restaurantDetail;
  bool _fav = false;

  List<Order> _orderFood = [];
  List<Order> _orderDrink = [];

  List<Order> _transaksi = [];
  var _idSet = <String>{};
  List<Order> _distinct = [];
  int _itemCount = 0;
  int _amount = 0;

  ResultState get state => _state;

  String get message => _message;

  RestaurantDetail get restaurantDetail => _restaurantDetail;

  bool get fav => _fav;

  List<Order> get orderFood => _orderFood;

  List<Order> get orderDrink => _orderDrink;

  List<Order> get transaksi => _transaksi;

  get idSet => _idSet;

  List<Order> get distinct => _distinct;

  get itemCount => _itemCount;

  get amount => _amount;

  set fav(bool fav) {
    _fav = fav;
    notifyListeners();
  }

  set orderFood(List<Order> food) {
    _orderFood = food;
    notifyListeners();
  }

  set orderDrink(List<Order> drink) {
    _orderDrink = drink;
    notifyListeners();
  }

  Future<dynamic> fetchDetailRestaurant({required String id}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      _clearOrderDatas();

      final RestaurantDetail restaurant =
          await ApiService().getDetailRestaurant(id: id);
      _orderFood = generateListOrder(
        restaurant.restaurant.menus.foods,
        'Makanan',
        true,
      );
      _orderDrink = generateListOrder(
        restaurant.restaurant.menus.drinks,
        'Minuman',
        false,
      );

      _state = ResultState.hasData;
      notifyListeners();
      return _restaurantDetail = restaurant;
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

  List<Order> generateListOrder(List<Category> food, String type, bool isFood) {
    //buat list of Order
    List<Order> order = [];
    for (int i = 0; i < food.length; i++) {
      order.add(
        Order(
          id: '$type${i + 1}',
          name: food[i].name,
          qty: 0,
          fav: false,
          price: 12000,
          food: isFood,
        ),
      );
    }
    return order;
  }

  void tambahTransaksi(Order order) {
    //tambahkan item ke list transaksi
    _transaksi.add(order);

    //buat set of string idSet. kemudian tambah item ke dalam list distinct berdasarkan idSet
    for (var d in _transaksi) {
      if (_idSet.add(d.id)) {
        _distinct.add(d);
        notifyListeners();
      }
    }

    // hitung itemCount
    _itemCount = _distinct.fold(0, (sum, item) => sum + item.qty);

    //hitung amount
    _amount = _distinct.fold(0, (sum, item) => sum + item.price * item.qty);

    //hapus item dengan qty < 1 dari list distinct
    for (int i = 0; i < _distinct.length; i++) {
      if (_distinct[i].qty < 1) {
        _idSet.remove(_distinct[i].id);
        _distinct.remove(_distinct[i]);
        notifyListeners();
      }
    }

    //hapus list transaksi
    _transaksi.clear();
    notifyListeners();
  }

  void _clearOrderDatas() {
    _distinct.clear();
    _orderFood.clear();
    _orderDrink.clear();
    _idSet.clear();
  }
}
