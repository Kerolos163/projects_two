import 'dart:developer';

import 'package:flutter/material.dart';
import '../../Features/user/Product/view/product_screen.dart';
import '../../Features/Profile/view/profile_screen.dart';
import '../../Features/user/Favorite/view/favorite_screen.dart';
import '../../Features/user/Home/view/home_screen.dart';
import '../../Features/user/cart/view/cart_screen.dart';
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
}
