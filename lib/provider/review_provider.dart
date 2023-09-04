import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/custom_exception.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/add_review_model.dart';
import 'package:http/http.dart' as http;

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  final String nama;
  final String review;

  ReviewProvider({
    required this.apiService,
    required this.nama,
    required this.id,
    required this.review,
  }) {
    _postReview(id: id, nama: nama, review: review);
  }

  ResultState _state = ResultState.loading;
  String _message = '';
  final bool _error = false;

  ResultState get state => _state;

  String get message => _message;

  bool get error => _error;

  Future<dynamic> _postReview({
    required String id,
    required String nama,
    required String review,
  }) async {
    final http.Client httpClient = http.Client();

    try {
      if (_state != ResultState.loading) {
        _state = ResultState.loading;
        _message = 'Memuat pencarian data';
        notifyListeners();
      }

      final AddReview addReview = await ApiService(httpClient: httpClient)
          .postReview(id: id, nama: nama, review: review);
      if (addReview.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = addReview.message;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _message = addReview.message;
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
