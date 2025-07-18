import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/models/user_model.dart';
import '../../../../Core/utils/app_constants.dart';

class DetailsProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  ApiState state = ApiState.initial;
  bool isFavorite = false;
  late UserModel localData;
  String message = '';
  final List<ProductModel> _cartItems = [];

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
    state = ApiState.loading;
    notifyListeners();
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
    state = ApiState.loading;
    notifyListeners();
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

  Future<void> addToCart(ProductModel product) async {
    // ✅ تحميل البيانات المحفوظة من SharedPreferences
    await loadCartFromStorage();

    final existingIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
    } else {
      _cartItems.add(product.copyWith(quantity: 1));
    }

    await saveCartToStorage();
    notifyListeners();
  }

  Future<void> saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cartItems.map((product) => product.toJson()).toList();
    await prefs.setString('user_cart', jsonEncode(cartJson));
  }

  Future<void> loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('user_cart');
    if (cartString != null) {
      final List decoded = jsonDecode(cartString);
      _cartItems.clear();
      _cartItems.addAll(decoded.map((item) => ProductModel.fromJson(item)));
    }
  }
}
