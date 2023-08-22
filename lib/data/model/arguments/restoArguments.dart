import 'package:submission_resto/data/model/transaction/order_model.dart';

class RestoArguments {
  final String idResto;
  final List<Order> order;

  RestoArguments(this.idResto, this.order);
}
