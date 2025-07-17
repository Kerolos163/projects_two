import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Features/admin/categories_dashboard/display_categories/view/display_categories.dart';
import 'package:projects_two/Features/admin/categories_dashboard/viewmodel/categories_dashboard_provider.dart';
import 'package:projects_two/Features/admin/orders_dashboard/display_orders/view/display_orders_screen.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import 'package:projects_two/Features/admin/products_dashboard/display_products/view/dashboard_display_products_screen.dart';
import 'package:projects_two/Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';
import 'package:projects_two/Features/admin/users_dashboard/display_users/view/display_users_screen.dart';
import 'package:projects_two/Features/admin/users_dashboard/viewmodel/users_dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Core/constant/image.dart';
import '../../../profile/view/profile_screen.dart';
import '../../../../Core/constant/app_colors.dart';
import '../../../../Core/constant/app_strings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  late final ProductsDashboardProvider _productsProvider;
  late final CategoriesDashboardProvider _categoriesProvider;
  late final OrdersDashboardProvider _ordersProvider;
  late final UserDashboardProvider _usersProvider;

  @override
  void initState() {
    super.initState();
    _productsProvider = getIt<ProductsDashboardProvider>()..fetchAllProducts();
    _categoriesProvider = getIt<CategoriesDashboardProvider>()..fetchCategoriesAndSubcategories();
    _ordersProvider = getIt<OrdersDashboardProvider>()..fetchAllOrders();
    _usersProvider = getIt<UserDashboardProvider>()..fetchUsers();
  }

  @override
  void dispose() {
    _productsProvider.dispose();
    _categoriesProvider.dispose();
    _ordersProvider.dispose();
    _usersProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ChangeNotifierProvider.value(
            value: _productsProvider,
            child: const DashboardDisplayProductsScreen(),
          ),
          ChangeNotifierProvider.value(
            value: _categoriesProvider,
            child: const DashboardDisplayCategoriesScreen(),
          ),
          ChangeNotifierProvider.value(
            value: _ordersProvider,
            child: const DashboardDisplayOrdersScreen(),
          ),
          ChangeNotifierProvider.value(
            value: _usersProvider,
            child: const DashboardDisplayUsersScreen(),
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImagePath.products,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? AppColors.primary : AppColors.black,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            label: AppStrings.products.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            label: AppStrings.categories.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImagePath.orders,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? AppColors.primary : AppColors.black,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            label: AppStrings.orders.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.supervised_user_circle_outlined),
            label: AppStrings.users.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_2_outlined),
            label: AppStrings.profile.tr(),
          ),
        ],
      ),
    );
  }
}
