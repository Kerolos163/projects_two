import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CategoryModel> subcategories;
  final CategoryModel? parent;


  const CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.subcategories = const [],
    this.parent,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image']??  '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      subcategories:
          (json['subcategories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      // Parent is usually not deserialized directly to avoid circular nesting
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'subcategories': subcategories.map((e) => e.toJson()).toList(),
    };
  }

  CategoryModel copyWithSubcategories(List<CategoryModel> subs) {
    return CategoryModel(
      id: id,
      name: name,
      slug: slug,
      image: image,
      createdAt: createdAt,
      updatedAt: updatedAt,
      subcategories: subs,
      parent: parent,
    );
  }

  CategoryModel copyWithParent(CategoryModel parentCategory) {
    return CategoryModel(
      id: id,
      name: name,
      slug: slug,
      image: image,
      createdAt: createdAt,
      updatedAt: updatedAt,
      subcategories: subcategories,
      parent: parentCategory,
    );
  }

  factory CategoryModel.empty() {
    return const CategoryModel(
      id: '',
      name: '',
      image: '',
      slug: '',
      subcategories: [],
      parent: null,
    );
  }

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        image,
        createdAt,
        updatedAt,
        subcategories,
        parent,
      ];
}
