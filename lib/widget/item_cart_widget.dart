import 'package:flutter/material.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';

class ItemCartWidget extends StatefulWidget {
  final TextTheme textTheme;
  final Order order;

  const ItemCartWidget({
    required this.textTheme,
    required this.order,
    Key? key,
  }) : super(key: key);

  @override
  State<ItemCartWidget> createState() => _ItemRestoWidgetState();
}

class _ItemRestoWidgetState extends State<ItemCartWidget> {
  List<Order> transaction = [];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getCurrentColorScheme(context);

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
          _itemMenu(colorScheme),
        ],
      ),
    );
  }

  Widget _itemMenu(ColorScheme colorScheme) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        child: AspectRatio(
          aspectRatio: 1.6,
          child: Container(
            color: colorScheme.secondary,
            child: widget.order.food
                ? Icon(
                    Icons.fastfood_rounded,
                    color: colorScheme.onSecondary,
                  )
                : Icon(Icons.emoji_food_beverage_rounded,
                    color: colorScheme.onSecondary),
          ),
        ),
      ),
      title: Text(
        widget.order.name,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${widget.order.qty} x Rp ${widget.order.price.toString()}',
      ),
    );
  }
}
