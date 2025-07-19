import 'package:flutter/material.dart';
import '../../Drawer/view/custom_drawer_widget.dart';
import '../../../../Core/Services/service_locator.dart';
import '../../../../Core/Theme/app_provider.dart';
import 'package:provider/provider.dart';

import '../../Home/viewmodel/home_provider.dart';
import '../../Product/viewmodel/product_provider.dart';
import 'widget/custom_bottom_navigation_bar.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductProvider>(
              create: (_) => getIt<ProductProvider>()..getProducts(),
            ),
            ChangeNotifierProvider<HomeProvider>(
              create: (_) => getIt<HomeProvider>()..loadHomeData(),
            ),
          ],
          builder: (context, child) => Scaffold(
            key: provider.scaffoldKey,
            drawer: CustomDrawer(),
            body: provider.screens[provider.currentIndex],
            bottomNavigationBar: CustomBottomNavigationBar(
              appProvider: provider,
            ),
          ),
        );
      },
    );
  }
}
