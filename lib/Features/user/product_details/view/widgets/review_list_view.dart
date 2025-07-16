
import 'package:flutter/material.dart';
import 'package:projects_two/Features/user/product_details/view/widgets/user_review_card.dart';

import '../../model/review_model.dart';

class ReviewListView extends StatelessWidget {
  const ReviewListView({super.key, required this.list});
  final List<ReviewModel> list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          UserReviewCard(model: list[index]),
      itemCount: list.length,
    );
  }
}