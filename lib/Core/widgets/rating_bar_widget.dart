import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../Core/constant/image.dart';
import '../../../../Core/widgets/svg_img.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({super.key, required this.initialRating});
  final double initialRating;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      ignoreGestures: true,
      itemSize: 20,
      initialRating: initialRating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
      itemBuilder: (context, _) => const SVGImage(path: ImagePath.starIcon),
      onRatingUpdate: (rating) {},
    );
  }
}