import 'package:flutter/material.dart';

class ListRestoWidget extends StatelessWidget {
  const ListRestoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        // color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        image: DecorationImage(
          image: NetworkImage(
              'https://restaurant-api.dicoding.dev/images/medium/14'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tempat Siang Hari'),
          Text('Surabaya'),
          Row(
            children: [
              Icon(Icons.star),
              Text('4.4'),
            ],
          )
        ],
      ),
    );
  }
}
