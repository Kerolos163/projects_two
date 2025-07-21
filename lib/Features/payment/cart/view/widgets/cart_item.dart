import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/models/product_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.isEven,
    required this.model,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  final bool isEven;
  final ProductModel model;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isEven
            ? Theme.of(context).colorScheme.primaryContainer
            : AppColors.primary.withAlpha((0.75 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Main product image
                        Center(
                          child: Image.network(
                            '${ApiEndPoints.baseUrl}${model.imageCover}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 30.r,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                          ),
                        ),

                        // Optional: Add a subtle gradient at the bottom for better text contrast
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                                stops: const [0, 0.7],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Product Details
                Expanded(
                  child: Column(
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
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        model.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isEven
                              ? AppColors.primary.withOpacity(0.8)
                              : Theme.of(
                                  context,
                                ).colorScheme.primaryContainer.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8.h),

                      // Price and Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${model.price} EGP',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: isEven
                                      ? AppColors.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),

                          // Quantity Controls
                          Container(
                            decoration: BoxDecoration(
                              color: isEven
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    size: 18.r,
                                    color: isEven
                                        ? AppColors.white
                                        : AppColors.black,
                                  ),
                                  onPressed: onDecrease,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Text(
                                    model.quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isEven
                                          ? AppColors.white
                                          : AppColors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 18.r,
                                    color: isEven
                                        ? AppColors.white
                                        : AppColors.black,
                                  ),
                                  onPressed: onIncrease,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Delete Button
          Positioned(
            top: -8.h,
            right: -8.w,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.close, size: 18.r, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
