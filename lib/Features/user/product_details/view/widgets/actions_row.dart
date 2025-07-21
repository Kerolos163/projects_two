import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../Core/constant/app_strings.dart';

import '../../../../../Core/constant/app_colors.dart';

class AddToCartButton extends StatelessWidget {
  final ProductModel product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await Provider.of<CartProvider>(
          context,
          listen: false,
        ).addToCart(product);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.addToCart.tr()),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
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
    );
  }
}
