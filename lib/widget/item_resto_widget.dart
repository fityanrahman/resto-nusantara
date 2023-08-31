import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';
import 'package:submission_resto/provider/order_provider.dart';

class ItemRestoWidget extends StatelessWidget {
  final TextTheme textTheme;
  final Order order;
  final Function tambahTransaksi;

  const ItemRestoWidget({
    required this.textTheme,
    required this.order,
    required this.tambahTransaksi,
    Key? key,
  }) : super(key: key);

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
          _itemQtyFav(),
        ],
      ),
    );
  }

  Widget _itemQtyFav() {
    return Consumer<OrderProvider>(builder: (context, state, _) {
      return Padding(
        padding: EdgeInsets.only(left: order.qty == 0 ? 16 : 0, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            order.qty == 0
                ? ElevatedButton(
                    onPressed: () {
                      order.qty++;
                      state.tambahTransaksi(order);
                    },
                    child: Text(
                      'Tambah',
                      style: textTheme.labelSmall,
                    ),
                  )
                : Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          minimumSize: Size.zero,
                          fixedSize: const Size(24, 24),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          order.qty--;
                          state.tambahTransaksi(order);
                        },
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(order.qty.toString()),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          minimumSize: Size.zero,
                          fixedSize: const Size(24, 24),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          order.qty++;
                          state.tambahTransaksi(order);
                        },
                        child: const Icon(
                          Icons.add,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
            IconButton(
              onPressed: () {
                order.fav = !order.fav;
              },
              icon: Icon(
                order.fav ? Icons.star : Icons.star_outline,
                color: Colors.orangeAccent,
              ),
            )
          ],
        ),
      );
    });
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
            child: order.food
                ? Icon(
                    Icons.fastfood_rounded,
                    color: colorScheme.onSecondary,
                  )
                : Icon(
                    Icons.emoji_food_beverage_rounded,
                    color: colorScheme.onSecondary,
                  ),
          ),
        ),
      ),
      title: Text(
        order.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Rp ${order.price.toString()}',
      ),
    );
  }
}
