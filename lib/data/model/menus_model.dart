import 'package:submission_resto/data/model/foods_model.dart';

class Menus {
  List<Foods>? foods;
  List<Foods>? drinks;

  Menus({this.foods, this.drinks});

  Menus.fromJson(Map<String, dynamic> json) {
    if (json['foods'] != null) {
      foods = json['foods'].map<Foods>((food) => Foods.fromJson(food)).toList();
    }
    if (json['drinks'] != null) {
      drinks =
          json['drinks'].map<Foods>((drink) => Foods.fromJson(drink)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.foods != null) {
      data['foods'] = this.foods!.map((v) => v.toJson()).toList();
    }
    if (this.drinks != null) {
      data['drinks'] = this.drinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
