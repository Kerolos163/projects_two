import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/models/product_model.dart';
import '../../../../../Core/widgets/rating_bar_widget.dart';

class ProductCardHome extends StatelessWidget {
  final ProductModel productModel;
  const ProductCardHome({super.key, required this.productModel});
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
                  Text(
                    productModel.title,
                    style: Theme.of(context).textTheme.titleMedium,
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
                  Text(
                    "${productModel.price}\$",
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(height: 2),
                  ),
                  SizedBox(height: 2),
                  RatingBarWidget(
                    initialRating:
                        double.tryParse(productModel.ratingsAverage) ?? 0.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
