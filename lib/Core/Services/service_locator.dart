import 'package:get_it/get_it.dart';
import 'stripe_service.dart';
import '../../Features/Auth/viewmodel/auth_provider.dart';
import '../../Features/Profile/viewmodel/profile_provider.dart';
import '../../Features/payment/cart/logic/cart_provider.dart';
import '../../Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import '../../Features/admin/categories_dashboard/viewmodel/categories_dashboard_provider.dart';
import '../../Features/admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import '../../Features/admin/products_dashboard/viewmodel/products_dashboard_provider.dart';
import '../../Features/admin/users_dashboard/viewmodel/users_dashboard_provider.dart';

import '../../Features/user/Favorite/viewmodel/favorite_provider.dart';
import '../../Features/user/Home/viewmodel/home_provider.dart';
import '../../Features/user/Product/viewmodel/product_provider.dart';
import '../../Features/user/product_details/viewmodel/details_provider.dart';
import '../Theme/app_provider.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static void init() {
    // getIt.registerLazySingleton<HomeProvider>(() => HomeProvider());
    // Register providers
    getIt.registerFactory<AppProvider>(() => AppProvider());
    getIt.registerFactory<AuthProvider>(() => AuthProvider());
    getIt.registerFactory<HomeProvider>(() => HomeProvider());
    getIt.registerFactory<ProductProvider>(() => ProductProvider());
    getIt.registerFactory<ProfileProvider>(() => ProfileProvider());
    getIt.registerFactory<CartProvider>(() => CartProvider());
    getIt.registerFactory<DetailsProvider>(() => DetailsProvider());
    getIt.registerFactory<FavoriteProvider>(() => FavoriteProvider());
    getIt.registerLazySingleton<StripeService>(() => StripeService());
    getIt.registerLazySingleton<ProductsDashboardProvider>(() => ProductsDashboardProvider());
    getIt.registerLazySingleton<CategoriesDashboardProvider>(() => CategoriesDashboardProvider());
    getIt.registerLazySingleton<OrdersDashboardProvider>(() => OrdersDashboardProvider());
    getIt.registerLazySingleton<UserDashboardProvider>(() => UserDashboardProvider());
    getIt.registerLazySingleton<AnalyticsDashboardProvider>(() => AnalyticsDashboardProvider());




  }
}
