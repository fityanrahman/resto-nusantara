import 'package:submission_resto/common/const_api.dart';

class CustomException implements Exception {
  final String message;
  final ResultState state;

  // Pass your message in constructor.
  CustomException(
    this.message,
    this.state,
  );

  @override
  String toString() {
    return message;
  }
}
