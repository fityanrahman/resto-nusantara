import 'package:submission_resto/common/const_api.dart';

class CustomException implements Exception {
  final String message;
  final ResultState state;

  CustomException(
      this.message, this.state); // Pass your message in constructor.

  @override
  String toString() {
    return message;
  }
}
