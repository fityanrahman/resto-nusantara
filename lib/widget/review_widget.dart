import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_detail_model.dart';

class UserReview extends StatelessWidget {
  final TextTheme textTheme;
  final CustomerReview customerReview;

  const UserReview(
      {required this.textTheme, required this.customerReview, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Color(0xffd9d9d9),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            customerReview.name,
            style: textTheme.titleMedium,
          ),
          Text(
            customerReview.date,
            style: textTheme.labelSmall,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            customerReview.review,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
