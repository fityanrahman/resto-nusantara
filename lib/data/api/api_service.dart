import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/model/restaurant/list_restaurant_model.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_detail_model.dart';

class ApiService {
  Future<ListRestaurant> getListRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$listResto'));

      final statusCode = response.statusCode;
      final result = jsonDecode(response.body);

      if (statusCode == 200) {
        return ListRestaurant.fromJson(result);
      } else {
        throw Exception('Gagal memuat daftar restoran');
      }
    } on SocketException {
      throw Exception('Silakan periksa koneksi internetmu dan coba lagi');
    } on TimeoutException {
      throw Exception('Waktu koneksi habis. Silakan coba lagi');
    }
  }

// Future<RestaurantDetail> getDetailRestaurant() async {
// }
}
