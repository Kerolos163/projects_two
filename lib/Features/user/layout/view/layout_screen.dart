import 'package:flutter/material.dart';
import 'package:projects_two/Features/user/Drawer/view/custom_drawer_widget.dart';
import '../../../../Core/Theme/app_provider.dart';
import 'package:provider/provider.dart';

import 'widget/custom_bottom_navigation_bar.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          key: provider.scaffoldKey,
          drawer: CustomDrawer(),
          body: provider.screens[provider.currentIndex],
          bottomNavigationBar: CustomBottomNavigationBar(appProvider: provider),
        );
      },
    );
  }
}
