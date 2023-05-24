import 'package:flutter/material.dart';

class CircleKotaWidget extends StatelessWidget {
  final String city;

  const CircleKotaWidget({
    required this.city,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              'https://restaurant-api.dicoding.dev/images/medium/14',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, _) =>
              const Center(child: Icon(Icons.error)),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            city,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
