import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../model/review_model.dart';
import 'slider_rating.dart';

class ReviewSection extends StatelessWidget {
  final double rating;
  final List<ReviewModel> reviews;
  const ReviewSection({super.key, required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.ratingAndReviews.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              rating.toString(),
              style: TextStyle(
                fontSize: 56,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 35),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SliderRating(
                    rating: "5",
                    value: calculatingRating(number: 5),
                  ),
                  SizedBox(height: 8),
                  SliderRating(
                    rating: "4",
                    value: calculatingRating(number: 4),
                  ),
                  SizedBox(height: 8),
                  SliderRating(
                    rating: "3",
                    value: calculatingRating(number: 3),
                  ),
                  SizedBox(height: 8),
                  SliderRating(
                    rating: "2",
                    value: calculatingRating(number: 2),
                  ),
                  SizedBox(height: 8),
                  SliderRating(
                    rating: "1",
                    value: calculatingRating(number: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  double calculatingRating({required int number}) {
    int counter = 0;

    for (int i = 0; i < reviews.length; i++) {
      if (double.tryParse(reviews[i].ratings)?.round() == number) {
        counter++;
      }
    }
    if (reviews.isEmpty) return 0;

    return counter / reviews.length;
  }
}
