import 'package:get_it/get_it.dart';
import 'package:projects_two/Core/Services/stripe_service.dart';
import 'package:projects_two/Features/Auth/viewmodel/auth_provider.dart';
import 'package:projects_two/Features/Profile/viewmodel/profile_provider.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
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
    getIt.registerFactory<CartProvider>(() => CartProvider());
    getIt.registerFactory<DetailsProvider>(() => DetailsProvider());
    getIt.registerFactory<FavoriteProvider>(() => FavoriteProvider());
    getIt.registerLazySingleton<StripeService>(() => StripeService());
  }
}
