import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Features/admin/products_dashboard/product_details/widgets/product_details_form.dart';
import 'package:projects_two/Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<ProductsDashboardProvider>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.editProduct.tr()),
        ),
        body: ProductDetailsForm(product: product),
      ),
    );
  }
}
