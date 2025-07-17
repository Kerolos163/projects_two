import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/models/order_model.dart';
import 'package:projects_two/Features/admin/orders_dashboard/order_details/widgets/status_dropdown.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';
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
