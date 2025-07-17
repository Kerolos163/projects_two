import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/models/recently_view_model.dart';
import '../../Features/user/Product/view/product_screen.dart';
import '../../Features/Profile/view/profile_screen.dart';
import '../../Features/user/Favorite/view/favorite_screen.dart';
import '../../Features/user/Home/view/home_screen.dart';
import '../../Features/user/cart/view/cart_screen.dart';
import '../api/api_end_points.dart';
import '../models/product_model.dart';
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

  //! 👉 Recently Viewed
  String getUserIdFromLocal() {
    String userInfo = PreferencesManager.getString(AppConstants.userInfo)!;
    UserModel localData = UserModel.fromJson(jsonDecode(userInfo));
    return localData.id;
  }

  List<RecentlyViewModel> recentlyViewed = [];
  void getRecentlyViewed() {
    recentlyViewed = [];
    List<String> rViewed =
        PreferencesManager.getStringList(AppConstants.recentlyViewed) ?? [];

    recentlyViewed = rViewed
        .map((e) => RecentlyViewModel.fromJson(jsonDecode(e)))
        .where((e) => e.userId == getUserIdFromLocal())
        .toList();
    log('recentlyViewed : $recentlyViewed');
    if (recentlyViewed.length > 10) {
      recentlyViewed = recentlyViewed.sublist(5);
    }
    notifyListeners();
  }

  void addRecentlyViewed({required ProductModel product}) {
    RecentlyViewModel model = RecentlyViewModel(
      userId: getUserIdFromLocal(),
      recentlyViewed: product,
    );

    if (!recentlyViewed.contains(model)) {
      recentlyViewed.add(model);
    }

    PreferencesManager.setStringList(
      AppConstants.recentlyViewed,
      recentlyViewed.map((e) => jsonEncode(e.toJson())).toList(),
    );

    getRecentlyViewed();
    notifyListeners();
  }
}
