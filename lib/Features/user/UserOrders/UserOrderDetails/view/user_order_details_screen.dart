import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../../../../Core/models/order_model.dart';
import '../../../../admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import '../../../../admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';

class UserOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const UserOrderDetailsScreen({super.key, required this.order});

  double calculateTotal() {
    double total = 0;
    for (var orderProduct in order.products) {
      final product = orderProduct.product;
      if (product != null && product.price != null) {
        total += product.price! * orderProduct.quantity;
      }
    }
    return total;
  }

  double calculateDiscountedTotal(double total) {
    if (order.copon == null || order.copon == "non") return total;
    
    final coupon = order.copon!.toLowerCase();
    double discountPercentage = 0;
    
    if (coupon.contains('cpn5')) {
      discountPercentage = 0.05;
    } else if (coupon.contains('cpn10')) {
      discountPercentage = 0.10;
    } else if (coupon.contains('cpn15')) {
      discountPercentage = 0.15;
    } else if (coupon.contains('cpn20')) {
      discountPercentage = 0.20;
    }
    
    return total * (1 - discountPercentage);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = order.date?.toLocal().toString().split('.').first ?? '';
    final total = calculateTotal();
    final discountedTotal = calculateDiscountedTotal(total);
    final hasDiscount = order.copon != null && order.copon != "non";

    return Consumer<OrdersDashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.orderDetails.tr()),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                CustomLabel(text: AppStrings.orderId.tr()),
                CustomTextfield(
                  controller: TextEditingController(text: order.oId.toString()),
                  hint: "",
                  enabled: false,
                ),

                CustomLabel(text: AppStrings.paymentMethod.tr()),
                CustomTextfield(
                  controller: TextEditingController(text: order.paymentMethod),
                  hint: "",
                  enabled: false,
                ),

                CustomLabel(text: AppStrings.date.tr()),
                CustomTextfield(
                  controller: TextEditingController(text: dateText),
                  hint: "",
                  enabled: false,
                ),

                CustomLabel(text: AppStrings.status.tr()),
                CustomTextfield(
                  controller: TextEditingController(text: order.status),
                  hint: "",
                  enabled: false,
                ),

                const SizedBox(height: 24),

                // Total Price Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.totalPrice.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${total.toStringAsFixed(2)} ${AppStrings.currency.tr()}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    if (hasDiscount) ...[
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.couponApplied.tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${order.copon}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.discountedPrice.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${discountedTotal.toStringAsFixed(2)} ${AppStrings.currency.tr()}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppStrings.youSaved.tr()} ${(total - discountedTotal).toStringAsFixed(2)} ${AppStrings.currency.tr()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  AppStrings.products.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
              
                ...order.products.map((orderProduct) {
                  final product = orderProduct.product;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: product?.imageCover != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${ApiEndPoints.baseUrl}${product!.imageCover}',
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppStrings.quantity.tr()}: ${orderProduct.quantity}',
                          ),
                          if (product?.price != null)
                            Text(
                              '${AppStrings.price.tr()}: ${product!.price} ${AppStrings.currency.tr()}',
                            ),
                          if (orderProduct.returnStatus != null &&
                              orderProduct.returnStatus != 'none')
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Chip(
                                label: Text(
                                  orderProduct.returnStatus == 'pending'
                                      ? AppStrings.returnPending.tr()
                                      : AppStrings.returned.tr(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    orderProduct.returnStatus == 'pending'
                                    ? Colors.orange
                                    : Colors.green,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 32),

                if (order.status.toLowerCase() == "fulfilled" &&
                    order.date != null &&
                    DateTime.now().difference(order.date!).inDays <= 14)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text(AppStrings.returnInitiated.tr())),
                      // );
                    },
                    child: Text(
                      AppStrings.returnOrder.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                else if (order.status.toLowerCase() == "pending")
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      provider.updateOrderStatus(
                        orderId: order.oId!, 
                        newStatus: "cancelled", 
                        email: order.cust!.email
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.orderCancelled.tr())),
                      );
                      provider.fetchOrdersForCurrentUser();
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.cancelOrder.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                const SizedBox(height: 24),

                Center(
                  child: Text(
                    AppStrings.contactSupport.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}