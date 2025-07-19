import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/multiple_image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects_two/Features/admin/products_dashboard/product_details/widgets/product_catergory_dropdown.dart';
import 'package:projects_two/Features/admin/products_dashboard/product_details/widgets/product_image_preview.dart';
import 'package:projects_two/Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsForm extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsForm({super.key, required this.product});

  @override
  State<ProductDetailsForm> createState() => _ProductDetailsFormState();
}

class _ProductDetailsFormState extends State<ProductDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController titleCtrl;
  late final TextEditingController descCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController priceAfterCtrl;
  late final TextEditingController qtyCtrl;

  List<File> selectedImages = [];
  String? selectedCategoryId;
  String? selectedSubCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.product.title);
    descCtrl = TextEditingController(text: widget.product.description);
    priceCtrl = TextEditingController(text: widget.product.price.toString());
    priceAfterCtrl = TextEditingController(
      text: widget.product.priceAfterDiscount.toString() == 'null'
          ? ''
          : widget.product.priceAfterDiscount.toString(),
    );
    qtyCtrl = TextEditingController(text: widget.product.quantity.toString());

    selectedCategoryId = widget.product.category.id;
    selectedSubCategoryId = widget.product.subCategories.isNotEmpty == true
        ? widget.product.subCategories.first
        : null;
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    priceAfterCtrl.dispose();
    qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(ProductsDashboardProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await provider.updateProduct(
        id: widget.product.id,
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        quantity: int.parse(qtyCtrl.text.trim()),
        price: double.parse(priceCtrl.text.trim()),
        priceAfterDiscount: priceAfterCtrl.text.isNotEmpty
            ? double.parse(priceAfterCtrl.text.trim())
            : null,
        categoryId: selectedCategoryId!,
        subCategoryIds: selectedSubCategoryId != null
            ? [selectedSubCategoryId!]
            : null,
        imageCover: selectedImages.isNotEmpty ? selectedImages.first : null,
        images: selectedImages.length > 1 ? selectedImages.sublist(1) : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.productUpdated.tr())));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppStrings.error.tr()}: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete(ProductsDashboardProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmDelete.tr()),
        content: Text(AppStrings.deleteWarning.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.delete.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await provider.deleteProduct(widget.product.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.productDeleted.tr())),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.error.tr()}: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsDashboardProvider>(
      builder: (context, provider, _) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLabel(text: AppStrings.productName.tr()),
                CustomTextfield(
                  controller: titleCtrl,
                  hint: AppStrings.enterProductName.tr(),
                ),
                const SizedBox(height: 12),
                CustomLabel(text: AppStrings.description.tr()),
                CustomTextfield(
                  controller: descCtrl,
                  hint: AppStrings.enterDescription.tr(),
                ),
                const SizedBox(height: 12),
                _priceFields(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomLabel(text: AppStrings.quantity.tr()),
                          CustomTextfield(
                            controller: qtyCtrl,
                            hint: AppStrings.enterQuantity.tr(),
                            type: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomLabel(text: "Sold Quantity".tr()),
                          CustomTextfield(
                            enabled: false,
                            controller: TextEditingController(
                              text: widget.product.sold.toString(),
                            ),
                            hint: widget.product.sold.toString(),
                            type: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                ProductCategoryDropdowns(
                  initialCategoryId: selectedCategoryId,
                  initialSubCategoryId: selectedSubCategoryId,
                  onCategoryChanged: (id) {
                    setState(() {
                      selectedCategoryId = id;
                      selectedSubCategoryId = null;
                      provider.getSubCategories(id!);
                    });
                  },
                  onSubCategoryChanged: (id) =>
                      setState(() => selectedSubCategoryId = id),
                ),
                const SizedBox(height: 12),
                ProductImagePreview(imageUrl: widget.product.imageCover),
                MultiImagePickerWidget(
                  onImagesSelected: (images) =>
                      setState(() => selectedImages = images),
                ),
                if (selectedImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "${AppStrings.coverImage.tr()}: ${selectedImages.first.path.split('/').last}",
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _submit(provider),
                        child: Text(AppStrings.update.tr()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _confirmDelete(provider),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: Text(AppStrings.delete.tr()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _priceFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabel(text: AppStrings.price.tr()),
              CustomTextfield(
                controller: priceCtrl,
                hint: AppStrings.enterPrice.tr(),
                type: TextInputType.number,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabel(text: AppStrings.priceAfterDiscount.tr()),
              CustomTextfield(
                controller: priceAfterCtrl,
                hint: AppStrings.enterDiscountPrice.tr(),
                type: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
