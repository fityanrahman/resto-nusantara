import 'package:flutter/material.dart';

class AddToCartButton extends StatefulWidget {
  final void Function() onPress;

  final int itemCount;
  final String restoName;
  final int amount;

  const AddToCartButton({
    required this.onPress,
    required this.itemCount,
    required this.restoName,
    required this.amount,
    super.key,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      onPressed: widget.onPress,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lanjut Bayar'),
                // Text(widget.restoName),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.shopping_cart),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
