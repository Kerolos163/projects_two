import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Core/Theme/app_provider.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/user/Drawer/view/widget/category_drawer_list_view.dart';
import 'package:projects_two/Features/user/Drawer/view/widget/drawer_header.dart';
import 'package:provider/provider.dart';

import '../../Home/viewmodel/home_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ChangeNotifierProvider.value(
        value: getIt<HomeProvider>(),
        builder: (context, child) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(14),
            physics: BouncingScrollPhysics(),
            children: [
              Consumer<AppProvider>(
                builder: (context, appProvider, child) {
                  return CustomDrawerHeader(appProvider: appProvider);
                },
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.categories.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              CategoryDrawerListView(),
            ],
          ),
        ),
      ),
    );
  }
}
