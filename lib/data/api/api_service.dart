import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/custom_exception.dart';
import 'package:submission_resto/data/model/restaurant/add_review_model.dart';
import 'package:submission_resto/data/model/restaurant/list_restaurant_model.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_detail_model.dart';
import 'package:submission_resto/data/model/restaurant/search_restaurant_model.dart';

class ApiService {
  final http.Client httpClient;

  ApiService({required this.httpClient});

  Future<ListRestaurant> getListRestaurants() async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl$listResto'));

      final statusCode = response.statusCode;

      if (statusCode == 200) {
        final result = jsonDecode(response.body);
        return ListRestaurant.fromJson(result);
      } else {
        throw CustomException(
            'Gagal memuat daftar restoran. (Kode error: $statusCode)',
            ResultState.error);
      }
    } on SocketException {
      throw const SocketException(errorInternet);
    } on TimeoutException {
      throw TimeoutException(errorTimeout);
    }
  }

  Future getDetailRestaurant({String? id}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$detailResto$id'));
      final statusCode = response.statusCode;
      final result = jsonDecode(response.body);

      if (statusCode == 200) {
        return RestaurantDetail.fromJson(result);
      } else {
        throw CustomException(
            'Gagal memuat detail restoran', ResultState.error);
      }
    } on SocketException {
      throw const SocketException(errorInternet);
    } on TimeoutException {
      throw TimeoutException(errorTimeout);
    }
  }

  Future searchRestaurant({String? query}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$searchResto$query'));
      final statusCode = response.statusCode;
      final result = jsonDecode(response.body);

      if (statusCode == 200) {
        return SearchRestaurant.fromJson(result);
      } else {
        throw CustomException(
            'Gagal memuat pencarian restoran', ResultState.error);
      }
    } on SocketException {
      throw const SocketException(errorInternet);
    } on TimeoutException {
      throw TimeoutException(errorTimeout);
    }
  }

  Future postReview({
    required String id,
    required String nama,
    required String review,
  }) async {
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({'id': id, 'name': nama, 'review': review});

      final response = await http.post(
        Uri.parse('$baseUrl$reviewResto'),
        body: body,
        headers: header,
      );
      final statusCode = response.statusCode;
      final result = jsonDecode(response.body);

      if (statusCode == 201) {
        return AddReview.fromJson(result);
      } else {
        throw CustomException('Gagal memuat ulasan', ResultState.error);
      }
    } on SocketException {
      throw const SocketException(errorInternet);
    } on TimeoutException {
      throw TimeoutException(errorTimeout);
    }
  }
}
