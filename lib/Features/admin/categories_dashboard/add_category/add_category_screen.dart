import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';
import 'package:projects_two/Features/admin/categories_dashboard/viewmodel/categories_dashboard_provider.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_image_picker.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {


  @override
  void initState() {
    super.initState();
    final provider = context.read<CategoriesDashboardProvider>();
    provider.loadParentCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesDashboardProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(title: Text(AppStrings.addCategory.tr())),
            body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: provider.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomLabel(text: AppStrings.categoryName.tr()),
                            CustomTextfield(
                              controller: provider.nameController,
                              hint: AppStrings.enterProductName.tr(),
                            ),
                            const SizedBox(height: 16),
                            CustomLabel(text: AppStrings.parentCategory.tr()),
                            DropdownButtonFormField<String>(
                              value: provider.selectedCategory,
                              items: provider.categories
                                  .map(
                                    (catName) => DropdownMenuItem(
                                      value: catName,
                                      child: Text(
                                        catName == 'none' ? "None" : catName,
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                provider.setSelectedCategory(val);
                              },
                              validator: (val) => val == null
                                  ? AppStrings.requiredField.tr()
                                  : null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomImagePicker(
                              onImageSelected: (File file) {
                                provider.setSelectedImage(file);
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: provider.isSubmitting 
                                    ? null 
                                    : () => provider.submitForm(context),
                                child: provider.isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(AppStrings.submit.tr()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      );
  }
}