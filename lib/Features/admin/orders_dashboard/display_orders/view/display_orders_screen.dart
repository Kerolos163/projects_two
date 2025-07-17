import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/admin/orders_dashboard/display_orders/widgets/order_status_dropdown.dart';
import 'package:projects_two/Features/admin/orders_dashboard/display_orders/widgets/order_tile.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';

import 'package:provider/provider.dart';

class DashboardDisplayOrdersScreen extends StatefulWidget {
  const DashboardDisplayOrdersScreen({super.key});

  @override
  State<DashboardDisplayOrdersScreen> createState() =>
      _DashboardDisplayOrdersScreenState();
}

class _DashboardDisplayOrdersScreenState
    extends State<DashboardDisplayOrdersScreen> {

  String selectedStatus = 'All';
  final List<String> statusOptions = [
    'All', 'pending', 'shipping', 'fulfilled', 'rejected', 'refunded',
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.orders.tr(),
              style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
          backgroundColor: AppColors.white,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<OrdersDashboardProvider>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final filteredOrders = selectedStatus == 'All'
                ? controller.orders
                : controller.orders
                    .where((order) => order.status == selectedStatus)
                    .toList();

            return Column(
              children: [
                OrderStatusDropdown(
                  selectedStatus: selectedStatus,
                  statusOptions: statusOptions,
                  onChanged: (status) {
                    setState(() => selectedStatus = status);
                  },
                ),
                Expanded(
                  child: filteredOrders.isEmpty
                      ? Center(
                          child: Text(
                            "No orders available for this status.",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredOrders.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, color: Colors.transparent),
                          itemBuilder: (_, index) {
                            final order = filteredOrders[index];
                            return OrderTile(
                              order: order,
                              onUpdated: () async {
                                await controller.fetchAllOrders();
                                final updatedOrder = controller.orders.firstWhere(
                                  (o) => o.oId == order.oId,
                                  orElse: () => order,
                                );

                                if (selectedStatus != 'All' &&
                                    updatedOrder.status != selectedStatus) {
                                  setState(() => selectedStatus = 'All');
                                } else {
                                  setState(() {});
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      );
  }
}
