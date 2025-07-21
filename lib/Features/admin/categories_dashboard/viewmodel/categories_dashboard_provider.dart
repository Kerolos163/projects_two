import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../Core/constant/app_strings.dart';
import '../../../../Core/models/category_model.dart';
import '../service/category_service.dart';
import '../service/subcategory_service.dart';

class CategoriesDashboardProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  String? selectedCategory;
  File? selectedImage;
  CategoryModel? selectedCat;

  bool isLoading = false;
  List<String> categories = [];
  List<CategoryModel> categoriesWithSubs = [];
  Map<String, String> categoryNameToId = {};
  bool _hasLoaded = false;

  // Add this for better debugging
  bool isSubmitting = false;

  // Helpers
  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void _showDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onClose?.call();
            },
            child: Text(AppStrings.close.tr()),
          ),
        ],
      ),
    );
  }

  // Fetching
  Future<void> loadParentCategories() async {
    try {
      final result = await CategoryService().getCategories();
      categoryNameToId = {for (var cat in result) cat['name']: cat['_id']};
      categories = ['none', ...categoryNameToId.keys];
    } catch (e) {
      categories = ['none'];
      debugPrint('Failed to load categories: $e');
    }
    notifyListeners();
  }

  Future<void> fetchCategoriesAndSubcategories({
    bool forceReload = false,
  }) async {
    if (_hasLoaded && !forceReload) return;
    isLoading = true;
    categoriesWithSubs.clear();
    notifyListeners();

    try {
      final rawCategories = await CategoryService().getCategories();
      // categoriesWithSubs.clear();

      for (var catJson in rawCategories) {
        final mainCategory = CategoryModel.fromJson(catJson);
        List<CategoryModel> subcategories = [];

        try {
          final rawSubcats = await SubCategoryService().getSubCategories(
            mainCategory.id,
          );
          subcategories = (rawSubcats)
              .map((e) => CategoryModel.fromJson(e))
              .map((e) => e.copyWithParent(mainCategory))
              .toList();
        } catch (e) {
          debugPrint("Error loading subcategories: $e");
        }

        categoriesWithSubs.add(
          mainCategory.copyWithSubcategories(subcategories),
        );
      }

      _hasLoaded = true;
      debugPrint("Successfully loaded ${categoriesWithSubs.length} categories");
    } catch (e) {
      debugPrint("Failed to load categories: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (isSubmitting) {
      return;
    }

    if (selectedImage == null) {
      _showDialog(
        context,
        AppStrings.error.tr(),
        AppStrings.imageRequired.tr(),
      );
      return;
    }

    isSubmitting = true;
    notifyListeners();

    bool loaderDismissed = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final name = nameController.text.trim();

      Response response;

      if (selectedCategory == 'none') {
        response = await CategoryService().addCategory(
          name: name,
          image: selectedImage!,
        );
      } else {
        final categoryId = categoryNameToId[selectedCategory!];

        if (categoryId == null) {
          throw Exception("Category ID not found for: $selectedCategory");
        }

        response = await SubCategoryService().createSubCategory(
          categoryId: categoryId,
          name: name,
          image: selectedImage!,
        );
      }

      if (!loaderDismissed && Navigator.of(context).canPop()) {
        Navigator.pop(context);
        loaderDismissed = true;
      }

      if (response.statusCode == 201) {
        debugPrint("Success! Category added.");

        nameController.clear();
        selectedImage = null;
        selectedCategory = null;
        notifyListeners();
    
        _showDialog(
          context,
          AppStrings.success.tr(),
          AppStrings.categoryAdded.tr(),
          onClose: () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
        );
            await fetchCategoriesAndSubcategories(forceReload: true);
        
      } else {
        debugPrint("Error response: ${response.statusCode}");
        final responseBody = response.data.toString();
        _showDialog(
          context,
          AppStrings.error.tr(),
          '${AppStrings.somethingWentWrong.tr()}\n\nStatus: ${response.statusCode}\n\n$responseBody',
        );
      }
    } catch (e, _) {
      // Dismiss loader safely
      if (!loaderDismissed && Navigator.of(context).canPop()) {
        Navigator.pop(context);
        loaderDismissed = true;
      }

      // Handle different types of exceptions
      String errorMessage = '${AppStrings.somethingWentWrong.tr()}\n\n';

      if (e.toString().contains('SocketException')) {
        errorMessage +=
            'Network connection error. Please check your internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage += 'Request timeout. Please try again.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage += 'Invalid server response format.';
      } else {
        errorMessage += 'Error: ${e.toString()}';
      }

      _showDialog(context, AppStrings.error.tr(), errorMessage);
    } finally {
      // Reset submitting state
      isSubmitting = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSelectedImage(File? image) {
    selectedImage = image;
    notifyListeners();
  }

  // Fixed Update Method
  Future<void> updateCategoryOrSubcategory({
    required BuildContext context,
    required CategoryModel category,
    required String name,
    File? image,
  }) async {
    // Add loading state
    isLoading = true;
    notifyListeners();

    bool loaderDismissed = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final response = (selectedCat != null || category.parent != null)
          ? await SubCategoryService().updateSubCategory(
              id: category.id,
              category: selectedCat?.id ?? category.parent!.id,
              name: name,
              image: image,
            )
          : await CategoryService().updateCategory(
              id: category.id,
              name: name,
              image: image,
            );

      // Dismiss loader safely
      if (!loaderDismissed && Navigator.of(context).canPop()) {
        Navigator.pop(context);
        loaderDismissed = true;
      }

      if (response.statusCode == 200) {

        _showDialog(
          context,
          AppStrings.success.tr(),
          AppStrings.categoryUpdated.tr(),
          onClose: () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
        );
                  await fetchCategoriesAndSubcategories(forceReload: true);
      } else {
        final responseBody = response.data.toString();
        _showDialog(
          context,
          AppStrings.error.tr(),
          '${AppStrings.somethingWentWrong.tr()}\n\nStatus: ${response.statusCode}\n\n$responseBody',
        );
      }
    } catch (e) {
      // Dismiss loader safely
      if (!loaderDismissed && Navigator.of(context).canPop()) {
        Navigator.pop(context);
        loaderDismissed = true;
      }

      // Handle different types of exceptions
      String errorMessage = '${AppStrings.somethingWentWrong.tr()}\n\n';

      if (e.toString().contains('SocketException')) {
        errorMessage +=
            'Network connection error. Please check your internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage += 'Request timeout. Please try again.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage += 'Invalid server response format.';
      } else {
        errorMessage += 'Error: ${e.toString()}';
      }

      _showDialog(context, AppStrings.error.tr(), errorMessage);
    } finally {
      // Reset loading state
      isLoading = false;
      notifyListeners();
    }
  }

  // Fixed Delete Method
  Future<void> deleteCategoryOrSubcategory(
    BuildContext context,
    CategoryModel category,
  ) async {
    // Add loading state
    isLoading = true;
    notifyListeners();

    bool loaderDismissed = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      if (selectedCat != null || category.parent != null) {
        await SubCategoryService().deleteSubCategory(category.id);
      } else {
        await CategoryService().deleteCategory(category.id);
      }

      // Dismiss loader safely
      if (!loaderDismissed && Navigator.of(context).canPop()) {
        Navigator.pop(context);
        loaderDismissed = true;
      }

      _showDialog(
        context,
        AppStrings.success.tr(),
        AppStrings.categoryDeleted.tr(),
        onClose: () {
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context);
          }
          
        },
      );
      await fetchCategoriesAndSubcategories(forceReload: true);
      _hasLoaded = false;
    } catch (e) {
      // Dismiss loader safely
      if (!loaderDismissed && Navigator.of(context).canPop()) {
        Navigator.pop(context);
        loaderDismissed = true;
      }

      // Handle different types of exceptions
      String errorMessage = '${AppStrings.somethingWentWrong.tr()}\n\n';

      if (e.toString().contains('SocketException')) {
        errorMessage +=
            'Network connection error. Please check your internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage += 'Request timeout. Please try again.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage += 'Invalid server response format.';
      } else {
        errorMessage += 'Error: ${e.toString()}';
      }

      _showDialog(context, AppStrings.error.tr(), errorMessage);
    } finally {
      // Reset loading state
      isLoading = false;
      notifyListeners();
    }
  }
}
