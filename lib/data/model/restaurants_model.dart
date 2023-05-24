import 'package:submission_resto/data/model/menus_model.dart';

class Restaurants {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  String? rating;
  Menus? menus;

  Restaurants(
      {this.id,
        this.name,
        this.description,
        this.pictureId,
        this.city,
        this.rating,
        this.menus});

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'].toString();
    menus = json['menus'] != null ? new Menus.fromJson(json['menus']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['pictureId'] = this.pictureId;
    data['city'] = this.city;
    data['rating'] = this.rating;
    if (this.menus != null) {
      data['menus'] = this.menus!.toJson();
    }
    return data;
  }
}