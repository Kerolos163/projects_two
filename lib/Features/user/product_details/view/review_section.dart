import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  final double rating;
  const ReviewSection({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rating and reviews",
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
                children: const [
                  // SliderRating(rating: "5", value: 1.0),
                  // SizedBox(height: 8),
                  // SliderRating(rating: "4", value: 0.8),
                  // SizedBox(height: 8),
                  // SliderRating(rating: "3", value: 0.6),
                  // SizedBox(height: 8),
                  // SliderRating(rating: "2", value: 0.3),
                  // SizedBox(height: 8),
                  // SliderRating(rating: "1", value: 0.1),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
