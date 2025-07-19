import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String title;
  final String ratings;
  final User user;
  final String product;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.title,
    required this.ratings,
    required this.user,
    required this.product,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json["_id"],
    title: json["title"],
    ratings: json["ratings"],
    user: User.fromJson(json["user"]),
    product: json["product"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "ratings": ratings,
    "user": user.toJson(),
    "product": product,
    "createdAt": createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, title, ratings, user, product];
}

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? avatar;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "avatar": avatar,
  };

  @override
  List<Object?> get props => [id, firstName, lastName, avatar];
}
