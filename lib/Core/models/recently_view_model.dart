import 'package:equatable/equatable.dart';

import 'product_model.dart';

class RecentlyViewModel extends Equatable {
  final String userId;
  final ProductModel recentlyViewed;

  const RecentlyViewModel({required this.userId, required this.recentlyViewed});

  factory RecentlyViewModel.fromJson(Map<String, dynamic> json) =>
      RecentlyViewModel(
        userId: json["userId"],
        recentlyViewed: ProductModel.fromJson(json["recentlyViewed"]),
      );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "recentlyViewed": recentlyViewed.toJson(),
  };

  @override
  List<Object?> get props => [userId, recentlyViewed];
}
