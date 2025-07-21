import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/models/return_model.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';
import 'package:projects_two/Features/admin/returns_dashboard/return_details/widgets/dropdown.dart';
import 'package:projects_two/Features/admin/returns_dashboard/return_details/widgets/return_product_card.dart';
import 'package:projects_two/Features/admin/returns_dashboard/viewmodel/return_dashboard_provider.dart';
import 'package:provider/provider.dart';


class ReturnDetailsScreen extends StatefulWidget {
  final ReturnModel returnRequest;

  const ReturnDetailsScreen({super.key, required this.returnRequest});

  @override
  State<ReturnDetailsScreen> createState() => _ReturnDetailsScreenState();
}

class _ReturnDetailsScreenState extends State<ReturnDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController returnIdController;
  late TextEditingController customerIdController;
  late TextEditingController customerNameController;
  String? selectedStatus;
  late ReturnsDashboardProvider provider;

  @override
  void initState() {
    super.initState();

    provider = context.read<ReturnsDashboardProvider>();

    returnIdController = TextEditingController(text: widget.returnRequest.id.toString());
    customerIdController = TextEditingController(text: widget.returnRequest.order?.custId.toString());
    customerNameController = TextEditingController(
        text: widget.returnRequest.order?.cust?.fName ?? widget.returnRequest.order?.custId);
    selectedStatus = widget.returnRequest.status;
  }

  void _submitStatusUpdate() async {
    if (_formKey.currentState!.validate()) {
      final success = await provider.updateReturnStatus(
        returnId: widget.returnRequest.id?.toString() ?? '',
        newStatus: selectedStatus!,
      );

      if (success) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(AppStrings.success.tr()),
            content: Text("Return status updated".tr()),
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
      appBar: AppBar(title: Text("Return details".tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomLabel(text: "Return Id".tr()),
              CustomTextfield(controller: returnIdController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.customerId.tr()),
              CustomTextfield(controller: customerIdController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.customerName.tr()),
              CustomTextfield(controller: customerNameController, hint: "", enabled: false),

              CustomLabel(text: AppStrings.status.tr()),
              ReturnStatusDropdown(
                value: selectedStatus,
                onChanged: (val) => setState(() => selectedStatus = val),
              ),

              const SizedBox(height: 24),
              Text(AppStrings.products.tr(), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),

              ...widget.returnRequest.products!.map((rp) => ReturnProductCard(returnProduct: rp)),

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
