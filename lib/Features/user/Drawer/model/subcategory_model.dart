import 'package:equatable/equatable.dart';

class SubcategoryModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String image;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubcategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
      SubcategoryModel(
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        category: json["category"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "slug": slug,
    "image": image,
    "category": category,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    image,
    category,
    createdAt,
    updatedAt,
  ];
}
