import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';
import '../../Features/user/Product/view/product_screen.dart';
import '../../Features/Profile/view/profile_screen.dart';
import '../../Features/user/Favorite/view/favorite_screen.dart';
import '../../Features/user/Home/view/home_screen.dart';
import '../../Features/payment/cart/view/cart_screen.dart';
import '../api/api_end_points.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

import '../Services/preferences_manager.dart';

class AppProvider extends ChangeNotifier {
  // Theme Management
  bool isDark = PreferencesManager.getBool(AppConstants.isDarkMood) ?? false;

  //!Navigate With Filter
  String filter = "";

  // Navigation Management
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> get screens => [
    HomeScreen(),
    ProductScreen(categoryName: filter),
    CartScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  void changeTheme() {
    isDark = !isDark;
    PreferencesManager.setBool(AppConstants.isDarkMood, isDark);
    notifyListeners();
  }

  void changeIndex({required int index}) {
    filter = "";
    if (index == currentIndex) return;
    currentIndex = index;
    notifyListeners();
  }

  void changeIndexToProductWithFilter({required String filter}) {
    this.filter = filter;
    log('this.filter: ${this.filter}');
    currentIndex = 1;
    notifyListeners();
  }

  //? Get User Image
  ApiState state = ApiState.initial;
  ApiService apiService = ApiService();
  String? image;
  Future<void> getUserImage() async {
    String userInfo = PreferencesManager.getString(AppConstants.userInfo)!;
    UserModel localData = UserModel.fromJson(jsonDecode(userInfo));
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(
        ApiEndPoints.getUserbyId(id: localData.id),
      );
      image = response.data["data"]["avatar"];
      log('image:🤍 $image');
      state = ApiState.success;
    } catch (e) {
      log('error: $e');
      state = ApiState.error;
    }
    notifyListeners();
  }
}
