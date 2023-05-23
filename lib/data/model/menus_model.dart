import 'package:submission_resto/data/model/drinks_model.dart';
import 'package:submission_resto/data/model/foods_model.dart';

class Menus {
  List<Foods>? foods;
  List<Drinks>? drinks;

  Menus({this.foods, this.drinks});

  Menus.fromJson(Map<String, dynamic> json) {
    if (json['foods'] != null) {
      // foods = <Foods>[];
      // json['foods'].forEach((v) {
      //   foods!.add(new Foods.fromJson(v));
      // });
      foods = json['foods'].map<Foods>((food) => Foods.fromJson(food)).toList();
    }
    if (json['drinks'] != null) {
      // drinks = <Drinks>[];
      // json['drinks'].forEach((v) {
      //   drinks!.add(new Drinks.fromJson(v));
      // });
      drinks = json['drinks']
          .map<Drinks>((drink) => Drinks.fromJson(drink))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foods != null) {
      data['foods'] = this.foods!.map((v) => v.toJson()).toList();
    }
    if (this.drinks != null) {
      data['drinks'] = this.drinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
