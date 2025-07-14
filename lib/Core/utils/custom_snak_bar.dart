  import 'package:flutter/material.dart';
import '../constant/app_colors.dart';

customSnackBar(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }