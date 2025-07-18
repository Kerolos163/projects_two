import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Home/viewmodel/home_provider.dart';
import 'category_item.dart';

class CategoryDrawerListView extends StatelessWidget {
  const CategoryDrawerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return homeProvider.categories.isEmpty
            ? const SizedBox()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => CategoryDrawerItem(
                  item: homeProvider.categories[index],
                  subCategory: homeProvider.subCategory[index],
                ),
                itemCount: homeProvider.categories.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
              );
      },
    );
  }
}
