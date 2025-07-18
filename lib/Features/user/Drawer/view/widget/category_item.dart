import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../Core/Theme/app_provider.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/models/category_model.dart';
import '../../model/subcategory_model.dart';

class CategoryDrawerItem extends StatelessWidget {
  const CategoryDrawerItem({
    super.key,
    required this.item,
    required this.subCategory,
  });
  final CategoryModel item;
  final List<SubcategoryModel> subCategory;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: Border.all(color: Colors.transparent),
      collapsedShape: Border.all(color: Colors.transparent),
      backgroundColor: Colors.transparent,
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: "${ApiEndPoints.baseUrl}${item.image}",
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
          width: 50.r,
          height: 50.r,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(item.name),
      children: subCategory
          .map(
            (e) => Consumer<AppProvider>(
              builder: (context, appProvider, child) {
                return ListTile(
                  title: Text(e.name),
                  onTap: () {
                    appProvider.changeIndex(index: 1);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          )
          .toList(),
    );
  }
}
