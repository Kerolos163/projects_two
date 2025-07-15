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

  // Navigation Management
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> screens = const [
    HomeScreen(),
    ProductScreen(),
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
    if (index == currentIndex) return;
    currentIndex = index;
    notifyListeners();
  }
}
