import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Product/viewmodel/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../Core/Theme/app_provider.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/models/category_model.dart';
import '../../../Home/model/subcategory_model.dart';

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
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
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
              onExpansionChanged: (value) {
                if (subCategory.isEmpty) {
                  appProvider.changeIndex(index: 1);
                  productProvider.getProducts(
                    filter: item.name[item.name.length - 1] == 's' 
                    ? item.name.substring(0, item.name.length - 1) 
                    :
                  item.name
                  );
                  Navigator.pop(context);
                }
              },
              children: subCategory
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                      onTap: () {
                        appProvider.changeIndex(index: 1);
                        productProvider.getProducts(
                          filter: item.name[item.name.length - 1] == 's'
                              ? item.name.substring(0, item.name.length - 1)
                              : item.name,
                          subFilterId: e.id,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}
