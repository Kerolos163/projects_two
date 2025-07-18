import 'package:flutter/material.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:provider/provider.dart';

import '../../../Home/viewmodel/home_provider.dart';
import '../../viewmodel/drawer_provider.dart';
import 'category_item.dart';

class CategoryDrawerListView extends StatelessWidget {
  const CategoryDrawerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<DrawerProvider>(),
      builder: (context, child) => Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return Consumer<DrawerProvider>(
            builder: (context, drawerProvider, child) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => CategoryDrawerItem(
                  numOfCategory: homeProvider.categories.length,
                  drawerProvider: drawerProvider,
                  index: index,
                  item: homeProvider.categories[index],
                ),
                itemCount: homeProvider.categories.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
              );
            },
          );
        },
      ),
    );
  }
}
