import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/multiple_image_picker.dart';
import 'package:projects_two/Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsDashboardProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomLabel(text: AppStrings.productName.tr()),
            CustomTextfield(
              controller: provider.nameController,
              hint: AppStrings.enterProductName.tr(),
            ),

            CustomLabel(text: AppStrings.description.tr()),
            CustomTextfield(
              controller: provider.descController,
              hint: AppStrings.enterDescription.tr(),
            ),

            CustomLabel(text: AppStrings.price.tr()),
            CustomTextfield(
              controller: provider.priceController,
              hint: AppStrings.enterPrice.tr(),
              type: TextInputType.number,
            ),

            CustomLabel(text: AppStrings.priceAfterDiscount.tr()),
            CustomTextfield(
              controller: provider.priceAfterDiscountController,
              hint: AppStrings.enterDiscountPrice.tr(),
              type: TextInputType.number,
            ),

            CustomLabel(text: AppStrings.stock.tr()),
            CustomTextfield(
              controller: provider.stockController,
              hint: AppStrings.enterStock.tr(),
              type: TextInputType.number,
            ),

            CustomLabel(text: AppStrings.category.tr()),
            DropdownButtonFormField<String>(
              value: provider.selectedCategory,
              items: provider.categories.map((cat) {
                return DropdownMenuItem(value: cat.id, child: Text(cat.name));
              }).toList(),
              onChanged: (val) => provider.setCategory(val),
              validator: (val) =>
                  val == null ? AppStrings.requiredField.tr() : null,
              decoration: _dropdownDecoration(),
            ),

            const SizedBox(height: 12),
            CustomLabel(text: AppStrings.subCategory.tr()),
            DropdownButtonFormField<String>(
              value: provider.selectedSubCategory,
              items: provider.subCategories.map((sub) {
                return DropdownMenuItem(value: sub.id, child: Text(sub.name));
              }).toList(),
              onChanged: (val) => provider.setSubCategory(val),
              decoration: _dropdownDecoration(),
            ),

            const SizedBox(height: 16),
            CustomLabel(text: AppStrings.productImage.tr()),
            MultiImagePickerWidget(
              onImagesSelected: (List<File> images) {
                provider.selectedImages = images;
              },
            ),

            if (provider.selectedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "${AppStrings.coverImage.tr()}: ${provider.selectedImages.first.path.split('/').last}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        );
      },
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
    );
  }
}
