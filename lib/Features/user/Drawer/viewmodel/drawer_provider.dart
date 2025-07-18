import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';

import '../../../../Core/api/api_end_points.dart';
import '../model/subcategory_model.dart';

class DrawerProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  ApiState state = ApiState.initial;
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
