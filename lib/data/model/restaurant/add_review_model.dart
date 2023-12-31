import 'package:submission_resto/data/model/restaurant/customer_review_model.dart';

class AddReview {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  AddReview({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReview.fromJson(Map<String, dynamic> json) => AddReview(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}
