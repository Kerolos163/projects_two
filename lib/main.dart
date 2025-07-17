import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/models/user_model.dart';
import 'package:projects_two/Core/utils/account_type.dart';
import 'package:projects_two/Features/admin/dashboard_screen/view/dashboard_screen.dart';
import 'Features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:provider/provider.dart';

import 'Core/Services/preferences_manager.dart';
import 'Core/Services/service_locator.dart';
import 'Core/Theme/app_provider.dart';
import 'Core/Theme/dark_theme.dart';
import 'Core/Theme/ligth_theme.dart';
import 'Core/utils/app_constants.dart';
import 'Features/Auth/views/login_screen.dart';
import 'Features/user/layout/view/layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.init();
  await PreferencesManager.init();
 // PreferencesManager.clear(); //! for testing ☠️
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale(AppConstants.enCode),
        Locale(AppConstants.arCode),
      ],
      path: 'assets/languages',
      startLocale: Locale(AppConstants.enCode),
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => ChangeNotifierProvider<AppProvider>(
        create: (_) => getIt<AppProvider>(),
        builder: (context, child) => Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            return MaterialApp(
              title: 'HandMade Store',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeMode: appProvider.isDark ? ThemeMode.dark : ThemeMode.light,
              theme: lightTheme,
              darkTheme: darkTheme,
              home: getStartScreen(),
            );
          },
        ),
      ),
    );
  }
}

Widget getStartScreen() {
  final bool? isFirstTime = PreferencesManager.getBool(AppConstants.firstTime);
  if (isFirstTime == null) return const OnboardingScreen();

  final String? token = PreferencesManager.getString(AppConstants.userTokenKey);
  if (token == null) return const LoginScreen();

  final String? userInfo = PreferencesManager.getString(AppConstants.userInfo);
  if (userInfo == null) return const LoginScreen();
  //todo check role
  final UserModel userModel = UserModel.fromJson(jsonDecode(userInfo));
  return userModel.role == AccountType.admin
      ? DashboardScreen()
      : LayoutScreen();

  //return LayoutScreen();
}
