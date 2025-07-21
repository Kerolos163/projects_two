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
    final returnStatus = orderProduct.returnStatus.toLowerCase();
    final statusColor = _getStatusColor(returnStatus);
    final statusText = _getStatusText(returnStatus);

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
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              )
            : const Icon(Icons.image_not_supported),
        title: Text(
          product?.title ?? AppStrings.unknownProduct.tr(),
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppStrings.quantity.tr()}: ${orderProduct.quantity}'),
            if (returnStatus != 'none')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: statusColor, width: 0.5),
                  ),
                  child: Text(
                    statusText,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'returned':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'returned':
        return AppStrings.returned.tr();
      case 'pending':
        return AppStrings.returnPending.tr();
      default:
        return "None".tr();
    }
  }
}