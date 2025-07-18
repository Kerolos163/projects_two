import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../viewmodel/details_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../../../../../../Core/constant/app_colors.dart';
import '../../../../../../../../Core/constant/image.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/widgets/rating_bar_widget.dart';
import '../../model/review_model.dart';

class UserReviewCard extends StatelessWidget {
  final ReviewModel model;
  final void Function()? onTap;
  const UserReviewCard({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: 4,
          shadowColor: Colors.grey.withValues(alpha: 0.3),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: model.user.avatar == null
                          ? AssetImage(ImagePath.avatar)
                          : NetworkImage(
                              "${ApiEndPoints.baseUrl}uploads/${model.user.avatar}",
                            ),
                      radius: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "${model.user.firstName} ${model.user.lastName}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    RatingBarWidget(
                      initialRating: double.tryParse(model.ratings) ?? 0.0,
                    ),
                    SizedBox(width: 10),
                    Text(
                      DateFormat(
                        "dd MMMM yyyy",
                      ).format(DateTime.parse(model.createdAt.toString())),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ReadMoreText(
                  model.title,
                  trimLines: 3,
                  trimExpandedText: AppStrings.showLess.tr(),
                  trimCollapsedText: AppStrings.showMore.tr(),
                  moreStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  lessStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer<DetailsProvider>(
          builder: (context, provider, child) {
            return provider.isMyReview(userReviewId: model.user.id)
                ? Positioned(
                    top: 3,
                    right: 3,
                    child: GestureDetector(
                      onTap: onTap,
                      child: CircleAvatar(
                        backgroundColor: AppColors.red,
                        radius: 16.r,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 18.w,
                        ),
                      ),
                    ),
                  )
                : SizedBox();
          },
        ),
      ],
    );
  }
}
