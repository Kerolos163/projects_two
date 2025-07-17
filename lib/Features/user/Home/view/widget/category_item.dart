import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel item;
  final void Function()? onTap;
  final bool islocal;
  const CategoryItem({
    super.key,
    required this.item,
    this.onTap,
    required this.islocal,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          islocal
              ? ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(30),
                  child: Image.asset(item.image!, width: 56, height: 56),
                )
              : ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: "${ApiEndPoints.baseUrl}${item.image}",
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
          SizedBox(height: MediaQuery.of(context).size.width * (5 / 812)),
          Center(
            child: Text(
              item.name,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
