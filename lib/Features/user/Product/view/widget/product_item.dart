import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/models/product_model.dart';
import '../../../../../Core/widgets/rating_bar_widget.dart';

class ProductItem extends StatelessWidget {
  final int index;
  final ProductModel productModel;

  const ProductItem({
    super.key,
    required this.index,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 2,
            color: AppColors.black.withValues(alpha: .3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: '${ApiEndPoints.baseUrl}${productModel.imageCover}',
              width: .5.sw,
              height: index % 2 == 0 ? 140.h : 200.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.grey[200], child: Icon(Icons.error)),
            ),
          ),
          Container(
            width: .5.sw,
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  productModel.description,
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(height: 2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '\$${productModel.price.toStringAsFixed(2)}',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(height: 2),
                    ),
                    ...[
                      SizedBox(width: 8.w),
                      Text(
                        '\$${productModel.priceAfterDiscount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              height: 2,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                RatingBarWidget(
                  initialRating: double.parse(productModel.ratingsAverage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
