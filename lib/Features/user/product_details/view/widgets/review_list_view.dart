import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/user/product_details/view/widgets/user_review_card.dart';
import '../../model/review_model.dart';
import '../../viewmodel/details_provider.dart';

class ReviewListView extends StatelessWidget {
  const ReviewListView({super.key, required this.list, required this.provider});
  final List<ReviewModel> list;
  final DetailsProvider provider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => UserReviewCard(
        model: list[index],
        onTap: () {
          showDeleteDialog(context, () async {
            await provider.deleteReview(reviewId: list[index].id);
            await provider.getProductReviews(productId: list[index].product);
          });
        },
      ),
      itemCount: list.length,
    );
  }

  void showDeleteDialog(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmDelete.tr()),
        content: Text(AppStrings.areYouSure.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(AppStrings.delete.tr()),
          ),
        ],
      ),
    );
  }
}
