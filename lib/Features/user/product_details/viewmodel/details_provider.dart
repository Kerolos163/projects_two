import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';

import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/models/user_model.dart';
import '../../../../Core/utils/app_constants.dart';
import '../model/review_model.dart';

class DetailsProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  ApiState state = ApiState.initial;
  bool isFavorite = false;
  late UserModel localData;
  late List<ReviewModel> reviews;
  String message = '';

  void changeFavorite({required String productId}) {
    isFavorite = !isFavorite;
    log('isFavorite: $isFavorite');
    if (isFavorite) {
      addToFavorite(productId: productId);
    } else {
      removeToFavorite(productId: productId);
    }
    notifyListeners();
  }

  Future<void> isFavorited({required String productId}) async {
    String userInfo = PreferencesManager.getString(AppConstants.userInfo)!;
    localData = UserModel.fromJson(jsonDecode(userInfo));
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(
        ApiEndPoints.userFavorites(id: localData.id),
      );
      final jsonData = response.data["data"]["products"] as List;
      for (var e in jsonData) {
        if (e["_id"] == productId) {
          isFavorite = true;
          log('isFavorite: $isFavorite');
        }
      }
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> addToFavorite({required String productId}) async {
    // state = ApiState.loading;
    // notifyListeners();
    try {
      final response = await apiService.post(
        ApiEndPoints.userFavorites(id: localData.id),
        body: {"productId": productId},
      );
      message = response.data["message"];
      log('message: $message');
      state = ApiState.success;
    } catch (err) {
      log('error: $err');
      message = err.toString();
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> removeToFavorite({required String productId}) async {
    // state = ApiState.loading;
    // notifyListeners();
    try {
      final response = await apiService.delete(
        ApiEndPoints.userFavorites(id: localData.id),
        body: {"productId": productId},
      );
      message = response.data["message"];
      log('message: $message');
      state = ApiState.success;
    } catch (err) {
      log('error: $err');
      message = err.toString();
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> getProductReviews({required String productId}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(
        ApiEndPoints.productReview(productId: productId),
      );
      final jsonData = response.data["data"] as List;
      reviews = jsonData.map((e) => ReviewModel.fromJson(e)).toList();
      state = ApiState.success;
    } catch (err) {
      log('error: $err');
      state = ApiState.error;
    }
    notifyListeners();
  }

  int myCurrentIndex = 0;
  final CarouselSliderController controller = CarouselSliderController();
}
