import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/models/order_model.dart';
import 'package:projects_two/Features/admin/orders_dashboard/display_orders/widgets/status_badge.dart';
import 'package:projects_two/Features/admin/orders_dashboard/order_details/view/order_details.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import 'package:provider/provider.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onUpdated;

  const OrderTile({super.key, required this.order, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersDashboardProvider>(
      builder: (context, provider, child) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: _getCardColor(order.status),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBorderColor(order.status),
                width: 1.2,
              ),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  order.products[0].product?.imageCover != null
                      ? '${ApiEndPoints.baseUrl}${order.products[0].product!.imageCover}'
                      : "https://via.placeholder.com/56",
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer: ${order.cust?.fName ?? order.custId}",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "Order #: ${order.oId}",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  StatusBadge(status: order.status),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward, size: 16),
              onTap: () async {
               
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => 
                    ChangeNotifierProvider.value(
                      value: provider,
                      child: OrderDetailsScreen(order: order),
                    ),
                  ),
                );
                if (updated == true) onUpdated();
              },
            ),
          ),
        );
      },
    );
  }

  Color _getCardColor(String status) {
    switch (status) {
      case 'fulfilled':
        return Colors.green.withOpacity(0.05);
      case 'shipping':
        return Colors.blue.withOpacity(0.05);
      case 'rejected':
        return Colors.red.withOpacity(0.05);
      case 'refunded':
        return Colors.orange.withOpacity(0.05);
      case 'pending':
      default:
        return Colors.grey.withOpacity(0.05);
    }
  }

  Color _getBorderColor(String status) {
    switch (status) {
      case 'fulfilled':
        return Colors.green;
      case 'shipping':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'refunded':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.grey;
    }
  }
}
