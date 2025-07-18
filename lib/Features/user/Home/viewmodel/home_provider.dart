import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/api/api_service.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/models/category_model.dart';
import '../../../../Core/models/product_model.dart';
import '../../Drawer/model/subcategory_model.dart';

class HomeProvider extends ChangeNotifier {
  ApiState state = ApiState.initial;
  ApiService apiService = ApiService();
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  Future<void> loadHomeData() async {
    log('loadHomeData');
    await getCategories();
    await getProducts();
  }

  Future<void> getCategories() async {
    categories = [];
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(ApiEndPoints.homeCategory);
      final jsonData = response.data["data"] as List;
      categories = jsonData.map((e) => CategoryModel.fromJson(e)).toList();
      for (var c in categories) {
        getSubCategory(categoryId: c.id);
      }
      state = ApiState.success;
    } catch (error) {
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> getProducts() async {
    products = [];
    state = ApiState.loading;
    notifyListeners();

    try {
      final response = await apiService.get(ApiEndPoints.homeProduct);
      final jsonData = response.data["data"] as List;
      products = jsonData.map((e) => ProductModel.fromJson(e)).toList();
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }

  //! SubCategory
    List<List<SubcategoryModel>> subCategory = [];

  Future<void> getSubCategory({required String categoryId}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(
        ApiEndPoints.getSubCategory(categoryId: categoryId),
      );
      final jsonData = response.data["data"] as List;
      subCategory.add(
        jsonData.map((e) => SubcategoryModel.fromJson(e)).toList(),
      );
      log('subCategory: $subCategory');
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }
}
