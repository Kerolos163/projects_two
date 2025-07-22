import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../../../../Core/models/order_model.dart';
import '../widgets/status_dropdown.dart';
import '../../viewmodel/orders_dashboard_provider.dart';
import '../../../products_dashboard/Shared_Components/Widgets/custom_label.dart';
import '../../../products_dashboard/Shared_Components/Widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../widgets/order_product_card.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController orderIdController;
  late TextEditingController customerIdController;
  late TextEditingController customerNameController;
  late TextEditingController paymentMethodController;
  late TextEditingController dateController;
  String? selectedStatus;
  late OrdersDashboardProvider provider;

  @override
  void initState() {
    super.initState();
    
    provider = context.read<OrdersDashboardProvider>();
    provider.loadAllOrderData(widget.order);

    orderIdController = TextEditingController(text: widget.order.oId.toString());
    customerIdController = TextEditingController(text: widget.order.custId);
    customerNameController = TextEditingController(
        text: widget.order.cust?.fName ?? widget.order.custId);
    paymentMethodController = TextEditingController(text: widget.order.paymentMethod);
    dateController = TextEditingController(
        text: widget.order.date?.toLocal().toString().split('.').first);
    selectedStatus = widget.order.status;
  }

  double calculateTotal() {
    double total = 0;
    for (var orderProduct in widget.order.products) {
      final product = orderProduct.product;
      if (product != null && product.price != null) {
        total += product.price! * orderProduct.quantity;
      }
    }
    return total;
  }

  double calculateDiscountedTotal(double total) {
    if (widget.order.copon == null || widget.order.copon == "non") return total;
    
    final coupon = widget.order.copon!.toLowerCase();
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

  void _submitStatusUpdate() async {
    if (_formKey.currentState!.validate()) {
      final success = await provider.updateOrderStatus(
        orderId: widget.order.oId ?? 0,
        newStatus: selectedStatus!,
        email: widget.order.cust?.email ?? 'default@example.com',
      );

      if (success) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(AppStrings.success.tr()),
            content: Text(AppStrings.orderUpdated.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: Text(AppStrings.close.tr()),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.error.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = calculateTotal();
    final discountedTotal = calculateDiscountedTotal(total);
    final hasDiscount = widget.order.copon != null && widget.order.copon != "non";

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.orderDetails.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomLabel(text: AppStrings.orderId.tr()),
              CustomTextfield(controller: orderIdController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.customerId.tr()),
              CustomTextfield(controller: customerIdController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.customerName.tr()),
              CustomTextfield(controller: customerNameController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.paymentMethod.tr()),
              CustomTextfield(controller: paymentMethodController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.date.tr()),
              CustomTextfield(controller: dateController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.status.tr()),
              StatusDropdown(
                value: selectedStatus,
                onChanged: (val) => setState(() => selectedStatus = val),
              ),

              // Price Summary Section
              const SizedBox(height: 24),
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
                      '${widget.order.copon}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
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
              Text(AppStrings.products.tr(), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),

              ...widget.order.products.map((op) => OrderProductCard(orderProduct: op)),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitStatusUpdate,
                  child: Text(AppStrings.updateStatus.tr()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}