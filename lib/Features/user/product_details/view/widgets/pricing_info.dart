import 'package:flutter/material.dart';

import '../../../../../Core/constant/app_colors.dart';

class PricingInfo extends StatelessWidget {
  const PricingInfo({super.key, required this.price, required this.priceAfterDiscount});
  final int price;
  final int priceAfterDiscount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          price.toStringAsFixed(2),
          style: TextStyle(
            color: Color(0xff808488),
            decoration: TextDecoration.lineThrough,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10),
        Text(
          price.toString(),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10),
        Text(
          priceAfterDiscount.toString(),
          style: TextStyle(
            color: Color(0xffFA7189),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
