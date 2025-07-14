import 'package:get_it/get_it.dart';
import 'package:projects_two/Features/Auth/viewmodel/auth_provider.dart';
import 'package:projects_two/Features/Profile/viewmodel/profile_provider.dart';

import '../../Features/user/Home/viewmodel/home_provider.dart';
import '../../Features/user/Product/viewmodel/product_provider.dart';
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
  }
}
