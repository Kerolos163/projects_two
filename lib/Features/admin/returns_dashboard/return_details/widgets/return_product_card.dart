import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/models/product_model.dart'; 

class ReturnProductCard extends StatelessWidget {
  final ProductModel returnProduct;

  const ReturnProductCard({super.key, required this.returnProduct});

  @override
  Widget build(BuildContext context) {
    final product = returnProduct;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: product.imageCover != null && product!.imageCover.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${ApiEndPoints.baseUrl}${product.imageCover}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.image_not_supported),
        title: Text(
          product.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text('${AppStrings.quantity.tr()}: ${returnProduct.quantity}'),
      ),
    );
  }
}
