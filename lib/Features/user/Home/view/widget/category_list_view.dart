import 'package:flutter/material.dart';
import 'category_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../Core/models/category_model.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key, required this.items});

  final List<CategoryModel> items;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: items.isEmpty,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: () {},
            child: CategoryItem(islocal: items.isEmpty, item: item),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
