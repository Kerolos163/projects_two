import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Features/user/ReturnOrders/view/return_orders_screen.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../../../../Core/models/order_model.dart';
import '../../../../admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import '../../../../admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';

class UserOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const UserOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateText = order.date?.toLocal().toString().split('.').first ?? '';

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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnOrderScreen(order: order)));
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
                  // // TODO: Add your cancel logic here
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text(AppStrings.orderCancelled.tr())),
                  // );
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
  }
}
