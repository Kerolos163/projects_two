import 'package:flutter/material.dart';
import '../../../../Core/widgets/rating_bar_widget.dart';
import '../../../../../../../Core/constant/app_colors.dart';
import '../../../../../../../Core/constant/image.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.3),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Avatar and Name
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(ImagePath.avatar),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Text(
                  "Rokaya Yasser",
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
                RatingBarWidget(initialRating: 4),
                SizedBox(width: 10),
                Text(
                  "01 June 2025",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 16),
            ReadMoreText(
              "I absolutely love this handmade bag! The quality is incredible — you can really tell that a lot of care and attention to detail went into making it. The stitching is neat, the fabric feels sturdy yet soft, and the design is one-of-a-kind. I’ve gotten so many compliments already!",
              trimLines: 3,
              trimExpandedText: " show less",
              trimCollapsedText: " show more",
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
    );
  }
}
