import 'package:flutter/material.dart';
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
          _itemMenu(),
        ],
      ),
    );
  }

  Widget _itemMenu() {
    return ListTile(
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        child: Image.network(
          'https://restaurant-api.dicoding.dev/images/medium/14',
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, _) => AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey,
              child: const Icon(Icons.error),
            ),
          ),
        ),
      ),
      title: Text(widget.order.name),
      subtitle: Text(
        '${widget.order.qty} x Rp ${widget.order.price.toString()}',
      ),
    );
  }
}