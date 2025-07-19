import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/models/category_model.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Features/admin/categories_dashboard/service/category_service.dart';
import 'package:projects_two/Features/admin/categories_dashboard/service/subcategory_service.dart';
import 'package:projects_two/Features/admin/products_dashboard/service/dashboard_products_service.dart';

class ProductsDashboardProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<CategoryModel> categories = [];
  List<CategoryModel> subCategories = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;
  String? selectedCategory;
  String? selectedSubCategory;

  // Add Product Form Controllers & State
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final priceAfterDiscountController = TextEditingController();
  List<File> selectedImages = [];

  Future<void> fetchAllProducts() async {
    print("Fetching all products...");
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _products = await _service.getAllProducts();
    } catch (e) {
      errorMessage = 'Failed to fetch products: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCategories() async {
    print("Fetching categories...");
    try {
      final result = await CategoryService().getCategories();
      categories = result.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage = 'Failed to load categories: $e';
    }
    notifyListeners();
  }

  Future<void> getSubCategories(String categoryId) async {
    try {
      final result = await SubCategoryService().getSubCategories(categoryId);
      subCategories = result.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage = 'Failed to load subcategories: $e';
    }
    notifyListeners();
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedImages.isEmpty) {
      _showError(context, "${AppStrings.requiredField.tr()} (images)");
      return;
    }

    final title = nameController.text.trim();
    final description = descController.text.trim();
    final price = double.tryParse(priceController.text) ?? 0;
    final priceAfterDiscount = double.tryParse(priceAfterDiscountController.text);
    final quantity = int.tryParse(stockController.text) ?? 0;

    await addProduct(
      title: title,
      description: description,
      quantity: quantity,
      price: price,
      priceAfterDiscount: priceAfterDiscount,
      categoryId: selectedCategory!,
      subCategoryIds: [if (selectedSubCategory != null) selectedSubCategory!],
      imageCover: selectedImages.first,
      images: selectedImages.length > 1 ? selectedImages.sublist(1) : [],
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.productAdd.tr())),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> addProduct({
    required String title,
    required String description,
    required int quantity,
    required double price,
    double? priceAfterDiscount,
    required String categoryId,
    List<String>? subCategoryIds,
    List<String>? colors,
    required File imageCover,
    List<File>? images,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.createProduct(
        title: title,
        description: description,
        quantity: quantity,
        price: price,
        priceAfterDiscount: priceAfterDiscount,
        categoryId: categoryId,
        subCategoryIds: subCategoryIds,
        colors: colors,
        imageCover: imageCover,
        images: images,
      );
      await fetchAllProducts();
    } catch (e) {
      errorMessage = 'Add product failed: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct({
    required String id,
    String? title,
    String? description,
    int? quantity,
    double? price,
    double? priceAfterDiscount,
    String? categoryId,
    List<String>? subCategoryIds,
    List<String>? colors,
    File? imageCover,
    List<File>? images,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.updateProduct(
        id: id,
        title: title,
        description: description,
        quantity: quantity,
        price: price,
        priceAfterDiscount: priceAfterDiscount,
        categoryId: categoryId,
        subCategoryIds: subCategoryIds,
        colors: colors,
        imageCover: imageCover,
        images: images,
      );
      await fetchAllProducts();
    } catch (e) {
      errorMessage = 'Update failed: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.deleteProduct(id);
      _products.removeWhere((element) => element.id == id);
    } catch (e) {
      errorMessage = 'Delete failed: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String? id) {
    selectedCategory = id;
    selectedSubCategory = null;
    if (id != null) getSubCategories(id);
    notifyListeners();
  }

  void setSubCategory(String? id) {
    selectedSubCategory = id;
    notifyListeners();
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void clearForm() {
    nameController.clear();
    descController.clear();
    priceController.clear();
    stockController.clear();
    priceAfterDiscountController.clear();
    selectedImages = [];
    selectedCategory = null;
    selectedSubCategory = null;
    notifyListeners();
  }
}
