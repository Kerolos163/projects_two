import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/models/product_model.dart';

import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/models/user_model.dart';
import '../../../../Core/utils/app_constants.dart';

class FavoriteProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  ApiState state = ApiState.initial;
  late UserModel localData;
  String message = '';

  List<ProductModel> favoriteList = [];

  Future<void> getFavoriteList() async {
    String userInfo = PreferencesManager.getString(AppConstants.userInfo)!;
    localData = UserModel.fromJson(jsonDecode(userInfo));
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(ApiEndPoints.userFavorites(id: localData.id));
      final jsonData = response.data["data"]["products"] as List;
      favoriteList = jsonData.map((e) => ProductModel.fromJson(e)).toList();
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }

    Future<void> removeToFavorite({required String productId}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.delete(
        ApiEndPoints.userFavorites(id: localData.id),
        body: {"productId": productId},
      );
      message = response.data["message"];
      log('message: $message');
      getFavoriteList();
      state = ApiState.success;
    } catch (err) {
      log('error: $err');
      message = err.toString();
      state = ApiState.error;
    }
    notifyListeners();
  }
}
