class Order {
  String id;
  String name;
  int qty;
  bool fav;
  int price;
  bool food;

  Order({
    required this.id,
    required this.name,
    required this.qty,
    required this.fav,
    required this.price,
    required this.food,
  });

  //untuk memudahkan debug (print/log)
  @override
  String toString() {
    return 'Order{id: $id,qty: $qty, price: $price}';
  }
}
