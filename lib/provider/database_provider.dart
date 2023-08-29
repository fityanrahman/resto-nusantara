import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/db/database_helper.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  ResultState _state = ResultState.loading;

  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  List<RestaurantsShort> _favorites = [];

  List<RestaurantsShort> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  /// Menbambahkan favorite
  void addFavorite(RestaurantsShort resto) async {
    try {
      await databaseHelper.insertFavorite(resto);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error : $e';
      notifyListeners();
    }
  }

  /// Mengembalikan status favorite dari artikel
  Future<bool> isFavorited(String id) async {
    final favoritedResto = await databaseHelper.getFavoriteById(id);
    return favoritedResto.isNotEmpty;
  }

  /// Menghapus favorite
  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error : $e';
      notifyListeners();
    }
  }
}
