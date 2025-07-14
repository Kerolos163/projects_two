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

  String _filterName = "All Products";

  String get filterName => _filterName;

  void setFilterName(String name) {
    _filterName = name;
    notifyListeners();
  }

  Future<void> getProducts() async {
    displayedProducts = [];
    state = ApiState.loading;
    notifyListeners();

    try {
      final response = await apiService.get(ApiEndPoints.homeProduct);
      final jsonData = response.data["data"] as List;
      displayedProducts = jsonData
          .map((e) => ProductModel.fromJson(e))
          .toList();
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
}
