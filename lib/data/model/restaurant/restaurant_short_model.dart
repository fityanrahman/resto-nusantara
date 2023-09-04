import 'package:equatable/equatable.dart';

class RestaurantsShort extends Equatable {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;

  RestaurantsShort({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
  });

  RestaurantsShort.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'].toDouble();
  }

  RestaurantsShort.fromJsonAlt(json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['pictureId'] = pictureId;
    data['city'] = city;
    data['rating'] = rating;
    return data;
  }

  //untuk memudahkan debug (print/log)
  @override
  String toString() {
    return 'RestaurantsShort{id: $id, name: $name, description: $description, pictureId: $pictureId, city: $city, rating: $rating}';
  }

  @override
  List<Object?> get props => [id, name, description, pictureId, city, rating];
}
