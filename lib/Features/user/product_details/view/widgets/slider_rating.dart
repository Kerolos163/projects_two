import 'package:flutter/material.dart';

import '../../../../../Core/constant/app_colors.dart';

class SliderRating extends StatelessWidget {
  const SliderRating({super.key, required this.rating, required this.value});
  final String rating;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            rating,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
