import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/data/model/restaurant/list_restaurant_model.dart';
import 'package:submission_resto/provider/home_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late HomeProvider sut;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    sut = HomeProvider(apiService: mockApiService);
  });

  group('fetchAllRestaurant', () {
    Map<String, dynamic> restos = {
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

    test('should update state to loading and fetch data successfully',
        () async {
      // Arrange
      when(() => mockApiService.getListRestaurants()).thenAnswer((_) async {
        return ListRestaurant.fromJson(restos);
      });
      verify(() => mockApiService.getListRestaurants()).called(1);

      // Act
      await sut.fetchAllRestaurant();

      // Assert
      expect(sut.state, ResultState.hasData);
      expect(sut.message, '');
      expect(sut.restaurants.isNotEmpty, true);
      if (kDebugMode) {
        print(sut.restaurants);
      }
    });
  });
}
