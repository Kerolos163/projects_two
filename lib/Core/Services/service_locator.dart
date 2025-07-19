import 'package:get_it/get_it.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:projects_two/Features/admin/categories_dashboard/viewmodel/categories_dashboard_provider.dart';
import 'package:projects_two/Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import 'package:projects_two/Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';
import 'package:projects_two/Features/admin/users_dashboard/viewmodel/users_dashboard_provider.dart';
import '../../Features/Auth/viewmodel/auth_provider.dart';
import '../../Features/Profile/viewmodel/profile_provider.dart';

import '../../Features/user/Favorite/viewmodel/favorite_provider.dart';
import '../../Features/user/Home/viewmodel/home_provider.dart';
import '../../Features/user/Product/viewmodel/product_provider.dart';
import '../../Features/user/product_details/viewmodel/details_provider.dart';
import '../Theme/app_provider.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static void init() {
    // Register providers
    getIt.registerFactory<AppProvider>(() => AppProvider());
    getIt.registerFactory<AuthProvider>(() => AuthProvider());
    getIt.registerFactory<HomeProvider>(() => HomeProvider());
    getIt.registerFactory<ProductProvider>(() => ProductProvider());
    getIt.registerFactory<ProfileProvider>(() => ProfileProvider());
    getIt.registerFactory<DetailsProvider>(() => DetailsProvider());
    getIt.registerFactory<FavoriteProvider>(() => FavoriteProvider());
    getIt.registerLazySingleton<ProductsDashboardProvider>(() => ProductsDashboardProvider());
    getIt.registerLazySingleton<CategoriesDashboardProvider>(() => CategoriesDashboardProvider());
    getIt.registerLazySingleton<OrdersDashboardProvider>(() => OrdersDashboardProvider());
    getIt.registerLazySingleton<UserDashboardProvider>(() => UserDashboardProvider());
    getIt.registerLazySingleton<AnalyticsDashboardProvider>(() => AnalyticsDashboardProvider());




  }
}
