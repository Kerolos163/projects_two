import 'package:flutter/material.dart';
import '../../data/category_data.dart';
import '../../../Product/viewmodel/product_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../Core/Theme/app_provider.dart';
import 'category_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../Core/models/category_model.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({
    super.key,
    required this.items,
    required this.appProvider,
  });
  final AppProvider appProvider;
  final List<CategoryModel> items;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: items.isEmpty,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.isEmpty ? categories.length : items.length,
        itemBuilder: (context, index) {
          final item = items.isEmpty ? categories[index] : items[index];
          return Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return GestureDetector(
                onTap: () {
                  appProvider.changeIndex(index: 1);
                  productProvider.getProducts(filter: item.name);
                },
                child: CategoryItem(islocal: items.isEmpty, item: item),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
