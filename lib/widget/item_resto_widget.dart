import 'package:flutter/material.dart';
import 'package:submission_resto/data/model/transaction/order_model.dart';

class ItemRestoWidget extends StatefulWidget {
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
  State<ItemRestoWidget> createState() => _ItemRestoWidgetState();
}

class _ItemRestoWidgetState extends State<ItemRestoWidget> {
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
          _itemQtyFav(),
        ],
      ),
    );
  }

  Widget _itemQtyFav() {
    return Padding(
          padding: EdgeInsets.only(
              left: widget.order.qty == 0 ? 16 : 0, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.order.qty == 0
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.order.qty++;
                          _addTransaction(widget.order);
                        });
                      },
                      child: Text(
                        'Tambah',
                        style: widget.textTheme.labelSmall,
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
                            setState(() {
                              widget.order.qty--;
                              _addTransaction(widget.order);
                            });
                          },
                          child: const Icon(
                            Icons.remove,
                            size: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(widget.order.qty.toString()),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            minimumSize: Size.zero,
                            fixedSize: const Size(24, 24),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.order.qty++;
                              _addTransaction(widget.order);
                            });
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
                  setState(() {
                    widget.order.fav = !widget.order.fav;
                  });
                },
                icon: Icon(
                  widget.order.fav ? Icons.star : Icons.star_outline,
                  color: Colors.orangeAccent,
                ),
              )
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
            'Rp ${widget.order.price.toString()}',
          ),
        );
  }

  //add order function
  void _addTransaction(Order order) {
    transaction.add(order);
    widget.tambahTransaksi(order);
  }
}