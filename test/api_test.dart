import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/custom_exception.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/list_restaurant_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiService apiService;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiService = ApiService(httpClient: mockHttpClient);
  });

  final Map<String, dynamic> restos = {
    "error": false,
    "message": "success",
    "count": 1,
    "restaurants": [
      {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description":
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
        "pictureId": "14",
        "city": "Medan",
        "rating": 4.2
      }
    ]
  };

  void callApiServiceSuccessReturnRestos() {
    when(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto'))).thenAnswer(
      (_) async => http.Response(jsonEncode(restos), 200),
    );
  }

  final ListRestaurant expectedListRestaurant = ListRestaurant.fromJson(restos);

  group('getListRestaurants apiService test', () {
    test(
        'should return a list of restaurants if the https call completes successfully',
        () async {
      callApiServiceSuccessReturnRestos();

      final result = await apiService.getListRestaurants();

      expect(result, equals(expectedListRestaurant));
      verify(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto')))
          .called(1);
    });

    test(
        'should throw a CustomException if the http call completes with an error',
        () async {
      when(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(() => apiService.getListRestaurants(),
          throwsA(isA<CustomException>()));
      verify(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto')))
          .called(1);
    });

    test('should throw a SocketException if a socket exception occurs',
        () async {
      when(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto')))
          .thenThrow(const SocketException('No internet'));

      expect(() => apiService.getListRestaurants(),
          throwsA(isA<SocketException>()));
      verify(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto')))
          .called(1);
    });

    test('should throw a TimeoutException if a timeout exception occurs',
        () async {
      when(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto')))
          .thenThrow(TimeoutException('Timeout'));

      expect(() => apiService.getListRestaurants(),
          throwsA(isA<TimeoutException>()));
      verify(() => mockHttpClient.get(Uri.parse('$baseUrl$listResto')))
          .called(1);
    });
  });
}
