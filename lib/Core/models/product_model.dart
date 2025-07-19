import 'package:equatable/equatable.dart';
import 'package:projects_two/Core/models/category_model.dart';

class ProductModel extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String description;
  final int quantity;
  final int sold;
  final int price;
  final int priceAfterDiscount;
  final List<dynamic> colors;
  final String imageCover;
  final List<dynamic> images;
  final CategoryModel category;
  final List<String> subCategories;
  final String ratingsAverage;
  final int ratingsQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final String categorieModelId;

  const ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.quantity,
    required this.sold,
    required this.price,
    required this.priceAfterDiscount,
    required this.colors,
    required this.imageCover,
    required this.images,
    required this.category,
    required this.subCategories,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.createdAt,
    required this.updatedAt,
    // required this.categorieModelId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["_id"],
    title: json["title"],
    slug: json["slug"],
    description: json["description"],
    quantity: json["quantity"],
    sold: json["sold"],
    price: json["price"],
    priceAfterDiscount: json["priceAfterDiscount"] ?? 0,
    colors: List<dynamic>.from(json["colors"].map((x) => x)),
    imageCover: json["imageCover"],
    images: List<dynamic>.from(json["images"].map((x) => x)),
    category: CategoryModel.fromJson(json["category"]),
    subCategories: List<String>.from(json["subCategories"].map((x) => x)),
    ratingsAverage: json["ratingsAverage"]?.toString() ?? '0',
    ratingsQuantity: json["ratingsQuantity"]?? 0,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    // categorieModelId: json["id"],
  );


  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "slug": slug,
    "description": description,
    "quantity": quantity,
    "sold": sold,
    "price": price,
    "priceAfterDiscount": priceAfterDiscount,
    "colors": List<dynamic>.from(colors.map((x) => x)),
    "imageCover": imageCover,
    "images": List<dynamic>.from(images.map((x) => x)),
    "category": category.toJson(),
    "subCategories": List<dynamic>.from(subCategories.map((x) => x)),
    "ratingsAverage": ratingsAverage,
    "ratingsQuantity": ratingsQuantity,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    // "id": categorieModelId,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    description,
    quantity,
    sold,
    price,
    priceAfterDiscount,
    colors,
    imageCover,
    images,
    category,
    subCategories,
    ratingsAverage,
    ratingsQuantity,
    createdAt,
    updatedAt,
    // categorieModelId,
  ];
}

// class Category extends Equatable {
//   final String id;
//   final String name;
//   final String categoryId;

//   const Category({
//     required this.id,
//     required this.name,
//     required this.categoryId,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) =>
//       Category(id: json["_id"], name: json["name"]);

//   Map<String, dynamic> toJson() => {"_id": id, "name": name, "id": categoryId};

//   @override
//   List<Object?> get props => [id, name, categoryId];
// }
