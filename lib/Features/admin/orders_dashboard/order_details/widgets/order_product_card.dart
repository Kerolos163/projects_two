import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../../../../Core/models/order_model.dart';

class OrderProductCard extends StatelessWidget {
  final OrderProduct orderProduct;

  const OrderProductCard({super.key, required this.orderProduct});

  @override
  Widget build(BuildContext context) {
    final product = orderProduct.product;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: product?.imageCover != null && product!.imageCover.isNotEmpty
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
          product?.title ?? AppStrings.unknownProduct.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text('${AppStrings.quantity.tr()}: ${orderProduct.quantity}'),
      ),
    );
  }
}
