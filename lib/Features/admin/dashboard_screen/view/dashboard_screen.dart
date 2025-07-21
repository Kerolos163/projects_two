import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Features/Profile/view/profile_screen.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/analytics_screen/view/analytics_screen.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:projects_two/Features/admin/categories_dashboard/display_categories/view/display_categories.dart';
import 'package:projects_two/Features/admin/categories_dashboard/viewmodel/categories_dashboard_provider.dart';
import 'package:projects_two/Features/admin/orders_dashboard/display_orders/view/display_orders_screen.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import 'package:projects_two/Features/admin/products_dashboard/display_products/view/dashboard_display_products_screen.dart';
import 'package:projects_two/Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';
import 'package:projects_two/Features/admin/returns_dashboard/display_returns/view/display_return_screen.dart';
import 'package:projects_two/Features/admin/returns_dashboard/viewmodel/return_dashboard_provider.dart';
import 'package:projects_two/Features/admin/users_dashboard/display_users/view/display_users_screen.dart';
import 'package:projects_two/Features/admin/users_dashboard/viewmodel/users_dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Core/constant/image.dart';
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
  late final AnalyticsDashboardProvider _analyticsProvider;
  late final ReturnsDashboardProvider _returnsProvider;

  @override
  void initState() {
    super.initState();
    _productsProvider = getIt<ProductsDashboardProvider>()..fetchAllProducts();
    _categoriesProvider = getIt<CategoriesDashboardProvider>()
      ..fetchCategoriesAndSubcategories();
    _ordersProvider = getIt<OrdersDashboardProvider>()..fetchAllOrders();
    _usersProvider = getIt<UserDashboardProvider>()..fetchUsers();
    _analyticsProvider = getIt<AnalyticsDashboardProvider>();
    _returnsProvider = getIt<ReturnsDashboardProvider>()..fetchAllReturns();
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
         
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ChangeNotifierProvider.value(
            value: _analyticsProvider,
            child: const AnalyticsScreen(),
          ),
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
            value: _returnsProvider,
            child: const DashboardDisplayReturnsScreen(),
          ),
          ChangeNotifierProvider.value(
            value: _usersProvider,
            child: const DashboardDisplayUsersScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            if (_currentIndex == index && index == 3) {
              _ordersProvider.fetchAllOrders();
            }

            if (_currentIndex != index && index == 3) {
              _ordersProvider.fetchAllOrders();
            }

            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImagePath.products,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? AppColors.primary : AppColors.black,
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
                _currentIndex == 3 ? AppColors.primary : AppColors.black,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            label: AppStrings.orders.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.rotate_left_outlined),
            label: "Returns".tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.supervised_user_circle_outlined),
            label: AppStrings.users.tr(),
          ),
        ],
      ),
    );
  }
}
