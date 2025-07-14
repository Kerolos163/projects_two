import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../constant/app_strings.dart';
import '../constant/image.dart';
import 'svg_img.dart';

class FilterHeader extends StatelessWidget {
  const FilterHeader({super.key, required this.itemCount});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Text(
            "$itemCount ${AppStrings.items.tr()}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Spacer(),
          filterHeaderButton(
            context,
            title: AppStrings.sort.tr(),
            iconPath: ImagePath.sortIcon,
            onTap: () => log("Sort button tapped"),
          ),
          SizedBox(width: 12),
          filterHeaderButton(
            context,
            title: AppStrings.filter.tr(),
            iconPath: ImagePath.filterIcon,
            onTap: () => log("Filter button tapped"),
          ),
        ],
      ),
    );
  }

  filterHeaderButton(
    BuildContext context, {
    required String title,
    required String iconPath,
    void Function()? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      splashColor: AppColors.primary.withAlpha(50),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 16,
              spreadRadius: 0,
              color: AppColors.black.withAlpha((0.08 * 255).round()),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.displayMedium),
            SizedBox(width: 4),
            SVGImage(path: iconPath),
          ],
        ),
      ),
    );
  }
}
