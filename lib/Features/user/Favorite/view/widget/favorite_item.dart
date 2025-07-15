import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/models/product_model.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import 'dart:ui' as ui;

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    super.key,
    required this.isEven,
    required this.model,
    this.onTap,
  });
  final bool isEven;
  final ProductModel model;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120.h,
          padding: const EdgeInsets.only(right: 8),

          decoration: BoxDecoration(
            color: isEven
                ? Theme.of(context).colorScheme.primaryContainer
                : AppColors.primary.withAlpha((0.75 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: '${ApiEndPoints.baseUrl}${model.imageCover}',
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 120.h,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: isEven
                                    ? AppColors.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          model.description,
                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                height: 1.4,
                                color: isEven
                                    ? AppColors.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                              ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "${AppStrings.quant.tr()} ${model.quantity}",
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: isEven
                                        ? AppColors.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                  ),
                            ),
                            Spacer(),
                            Text(
                              "${AppStrings.price2.tr()} ${model.price}",
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: isEven
                                        ? AppColors.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: -5,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.delete, color: AppColors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
