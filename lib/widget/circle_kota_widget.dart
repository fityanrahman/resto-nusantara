import 'package:flutter/material.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';

class CircleKotaWidget extends StatelessWidget {
  final String city;

  const CircleKotaWidget({
    required this.city,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getCurrentColorScheme(context);

    return SizedBox(
      width: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: colorScheme.secondaryContainer,
              child: Icon(
                Icons.location_on_rounded,
                color: colorScheme.onSecondaryContainer,
              ),
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
