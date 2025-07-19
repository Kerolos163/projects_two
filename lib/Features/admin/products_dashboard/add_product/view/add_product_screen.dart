import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/admin/products_dashboard/add_product/widgets/products_form_fields.dart';
import 'package:projects_two/Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsDashboardProvider>(
        builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.addProduct.tr())),
          body: Form(
            key: provider.formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProductFormFields(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => provider.submitForm(context),
                        child: Text(AppStrings.submit.tr()),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
  }
  );
  }
}

