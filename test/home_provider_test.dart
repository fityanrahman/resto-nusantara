import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/custom_exception.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/list_restaurant_model.dart';
import 'package:submission_resto/provider/home_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late HomeProvider sut;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
  });

  group('fetchAllRestaurant', () {
    Map<String, dynamic> restosSuccess = {
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

    Map<String, dynamic> restosEmpty = {
      "error": true,
      "message": "failed",
      "count": 0,
      "restaurants": []
    };

    test('when fetch data successfully should update state to hasData',
        () async {
      // Arrange
      when(() => mockApiService.getListRestaurants()).thenAnswer((_) async {
        return ListRestaurant.fromJson(restosSuccess);
      });
      sut = HomeProvider(apiService: mockApiService);
      verify(() => mockApiService.getListRestaurants()).called(1);

      // Act
      await sut.fetchAllRestaurant();

      // Assert
      expect(sut.state, ResultState.hasData);
      expect(sut.message, '');
      expect(sut.restaurants.isNotEmpty, true);
    });

    test('when fetch empty resto list should update state to noData', () async {
      // Arrange
      when(() => mockApiService.getListRestaurants())
          .thenAnswer((invocation) async {
        return ListRestaurant.fromJson(restosEmpty);
      });
      sut = HomeProvider(apiService: mockApiService);

      // Act
      await sut.fetchAllRestaurant();

      // Assert
      expect(sut.state, ResultState.noData);
      expect(sut.message, 'Data Kosong');
      expect(sut.restaurants.isEmpty, true);
    });

    test('when internet error should update state to networkError', () async {
      // Arrange
      when(() => mockApiService.getListRestaurants())
          .thenThrow(const SocketException(errorInternet));
      sut = HomeProvider(apiService: mockApiService);

      // Act
      await sut.fetchAllRestaurant();

      // Assert
      expect(sut.state, ResultState.networkError);
      expect(sut.message, errorInternet);
      expect(sut.restaurants.isEmpty, true);
    });

    test('when connection timeout should update state to timeoutError',
        () async {
      // Arrange
      when(() => mockApiService.getListRestaurants())
          .thenThrow(TimeoutException(errorTimeout));
      sut = HomeProvider(apiService: mockApiService);

      // Act
      await sut.fetchAllRestaurant();

      // Assert
      expect(sut.state, ResultState.timeoutError);
      expect(sut.message, errorTimeout);
      expect(sut.restaurants.isEmpty, true);
    });

    test('when server/other error should update state to error', () async {
      // Arrange
      when(() => mockApiService.getListRestaurants()).thenThrow(CustomException(
          'Gagal memuat daftar restoran. (Kode error: 500)',
          ResultState.error));
      sut = HomeProvider(apiService: mockApiService);

      // Act
      await sut.fetchAllRestaurant();

      // Assert
      expect(sut.state, ResultState.error);
      expect(sut.message, 'Gagal memuat daftar restoran. (Kode error: 500)');
      expect(sut.restaurants.isEmpty, true);
    });
  });
}
