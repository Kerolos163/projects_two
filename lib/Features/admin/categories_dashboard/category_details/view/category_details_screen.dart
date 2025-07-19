import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/models/category_model.dart';
import 'package:projects_two/Features/admin/categories_dashboard/viewmodel/categories_dashboard_provider.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_image_picker.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';

import 'package:provider/provider.dart';

import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  String? selectedCategory;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.category.name);
    selectedCategory = widget.category.parent?.name;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CategoriesDashboardProvider>();
      provider.loadParentCategories();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CategoriesDashboardProvider>();
    await provider.updateCategoryOrSubcategory(
      context: context,
      category: widget.category,
      name: titleController.text.trim(),
      image: pickedImage,
    );
  }

  Future<void> _confirmDelete() async {
    final provider = context.read<CategoriesDashboardProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.confirmDelete.tr()),
        content: Text(AppStrings.deleteWarning.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.delete.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteCategoryOrSubcategory(context, widget.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.editCategory.tr())),
      body: Consumer<CategoriesDashboardProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabel(text: AppStrings.categoryName.tr()),
                    CustomTextfield(
                      controller: titleController,
                      hint: AppStrings.enterProductName.tr(),
                    ),
                    const SizedBox(height: 16),
                    CustomLabel(text: AppStrings.parentCategory.tr()),
                      DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: provider.categories
                          .where((cat) => cat != widget.category.name && cat != 'none')
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat,
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                              ))
                          .toList(),
                      onChanged: widget.category.parent == null
                          ? null
                          : (val) => setState(() => provider.selectedCat = provider.categoriesWithSubs.where((cat)=>cat.name == val).first),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),  const SizedBox(height: 16),
                    CustomLabel(text: AppStrings.categoryImage.tr()),
                    const SizedBox(height: 8),
                    if (pickedImage != null)
                      Image.file(
                        pickedImage!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    else if (widget.category.image != null)
                      Image.network(
                        '${ApiEndPoints.baseUrl}${widget.category.image!}',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    else
                      Text(AppStrings.noImageAvailable.tr()),
                    const SizedBox(height: 12),
                    CustomImagePicker(
                      onImageSelected: (image) {
                        setState(() {
                          pickedImage = image;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(AppStrings.update.tr()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _confirmDelete,
                            child: Text(AppStrings.delete.tr()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
