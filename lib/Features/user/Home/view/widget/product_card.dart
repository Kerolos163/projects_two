import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/models/product_model.dart';
import '../../../../../Core/widgets/rating_bar_widget.dart';

class ProductCardHome extends StatelessWidget {
  final ProductModel productModel;
  final bool showRatings;
  const ProductCardHome({
    super.key,
    required this.productModel,
    required this.showRatings,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
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
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: "${ApiEndPoints.baseUrl}${productModel.imageCover}",
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: .7.sw,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      productModel.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    productModel.description,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium?.copyWith(height: 1.4),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      productModel.priceAfterDiscount == 0
                          ? const SizedBox()
                          : Row(
                              children: [
                                Text(
                                  productModel.price.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Color(0xff808488),
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                      Text(
                        "${productModel.priceAfterDiscount.toString() == "0" ? productModel.price.toStringAsFixed(2) : productModel.priceAfterDiscount.toStringAsFixed(2)}\$",
                        style: TextStyle(
                          color: Color(0xffFA7189),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),

                  showRatings
                      ? RatingBarWidget(
                          initialRating:
                              double.tryParse(productModel.ratingsAverage) ??
                              0.0,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
