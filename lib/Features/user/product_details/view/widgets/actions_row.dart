import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/constant/app_strings.dart';

import '../../../../../Core/constant/app_colors.dart';

class ActionsRow extends StatelessWidget {
  Future<void> Function()? addToCartMethod;
  ActionsRow({super.key, required this.addToCartMethod});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: addToCartMethod,
          icon: Icon(Icons.shopping_cart),
          label: Text(
            AppStrings.addToCart.tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primaryButton),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(width: 15),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.attach_money, color: Colors.white),
          label: Text(
            AppStrings.buyNow.tr(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 4,
            backgroundColor: AppColors.primaryButton,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
