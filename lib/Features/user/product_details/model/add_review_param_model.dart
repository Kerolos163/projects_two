import 'package:equatable/equatable.dart';

class AddReviewParamModel extends Equatable {
  final String title;
  final String rating;
  final String product;

  const AddReviewParamModel({
    required this.title,
    required this.rating,
    required this.product,
  });
  Map<String, dynamic> toJson() => {
    "title": title,
    "ratings": rating,
    "product": product,
  };

  @override
  List<Object?> get props => [title, rating, product];
}
