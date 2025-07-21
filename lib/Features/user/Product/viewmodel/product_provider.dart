import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/api/api_service.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  ApiState state = ApiState.initial;
  ApiService apiService = ApiService();
  List<ProductModel> displayedProducts = [];
  List<ProductModel> searchedProducts = [];
  List<ProductModel> subCategoryProducts = [];

  String _filterName = "All Products";

  String get filterName => _filterName;

  void setFilterName(String name) {
    _filterName = name;
    notifyListeners();
  }

  Future<void> getProducts({
    String filter = "",
    String subFilterId = "",
  }) async {
    if (filter != "") {
      _filterName = filter;
    } else {
      _filterName = "All Products";
    }
    displayedProducts = [];
    subCategoryProducts = [];
    state = ApiState.loading;
    notifyListeners();

    try {
      final response = await apiService.get(
        "${ApiEndPoints.homeProduct}?keyword=$filter",
      );
      final jsonData = response.data["data"] as List;
      displayedProducts = jsonData
          .map((e) => ProductModel.fromJson(e))
          .toList();

      if (subFilterId != "") {
        filterBySubCategory(subFilterId: subFilterId);
      }

      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }

  void searchedProductsByText({required String text}) {
    searchedProducts = [];
    state = ApiState.loading;
    notifyListeners();
    for (var item in displayedProducts) {
      if (item.title.toLowerCase().contains(text.toLowerCase())) {
        searchedProducts.add(item);
      }
    }
    state = ApiState.success;
    notifyListeners();
  }

  void filterBySubCategory({required String subFilterId}) {
    for (var item in displayedProducts) {
      if (item.subCategories.contains(subFilterId)) {
        subCategoryProducts.add(item);
      }
    }
  }

  Future<void> getSortedProducts(String sortQuery) async {
    displayedProducts = [];
    state = ApiState.loading;
    notifyListeners();

    try {
      final response = await apiService.get(
        ApiEndPoints.getSortedProducts(sortQuery: sortQuery),
      );
      final jsonData = response.data["data"] as List;
      displayedProducts = jsonData
          .map((e) => ProductModel.fromJson(e))
          .toList();
      state = ApiState.success;
    } catch (error) {
      log('error (sorted products): $error');
      state = ApiState.error;
    }
    notifyListeners();
  }
}
