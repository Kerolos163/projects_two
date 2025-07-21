
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
import 'package:projects_two/Features/splashscreen/customSplahscreen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'Core/Services/preferences_manager.dart';
import 'Core/Services/service_locator.dart';
import 'Core/Theme/app_provider.dart';
import 'Core/Theme/dark_theme.dart';
import 'Core/Theme/ligth_theme.dart';
import 'Core/utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.init();
  Stripe.publishableKey =
      "pk_test_51OuEXgP5ftpLBbyFbwXGDOdzbsnclAxoJMoyjGNN5GkdH3pXXxcXYekPORCW1SDKEVU2jwi4HHW7M58eCs1hLimV00wM7aBL4a";
  await PreferencesManager.init();
  // PreferencesManager.clear(); //! for testing ☠️
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCartData()),
      ],
      child: EasyLocalization(
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
    )
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
              home: CustomSplashScreen(),
            );
          },
        ),
      ),
    );
  }
}


