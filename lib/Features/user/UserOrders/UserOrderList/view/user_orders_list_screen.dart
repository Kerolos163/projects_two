import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import 'package:projects_two/Features/user/UserOrders/UserOrderDetails/view/user_order_details_screen.dart';

import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../Core/constant/app_strings.dart';

import '../../../../../Core/api/api_end_points.dart';

class UserOrdersListScreen extends StatefulWidget {
  const UserOrdersListScreen({super.key});

  @override
  State<UserOrdersListScreen> createState() => _UserOrdersListScreenState();
}

class _UserOrdersListScreenState extends State<UserOrdersListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersDashboardProvider>().fetchOrdersForCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.orders.tr()),
        centerTitle: true,
      ),
      body: Consumer<OrdersDashboardProvider>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = controller.orders;

          if (orders.isEmpty) {
            return Center(
              child: Text(
               "No orders found",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final order = orders[index];
              final product = order.products.first.product;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product?.imageCover != null
                        ? '${ApiEndPoints.baseUrl}${product!.imageCover}'
                        : "https://via.placeholder.com/50",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  "${AppStrings.orderNumber.tr()} #${order.oId}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${AppStrings.paymentMethod.tr()}: ${order.paymentMethod}"),
                    const SizedBox(height: 4),
                    _buildStatusBadge(order.status),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: context.read<OrdersDashboardProvider>(),
                        child: UserOrderDetailsScreen(order: order),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
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
