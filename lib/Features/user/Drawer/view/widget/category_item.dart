import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/Theme/app_provider.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Features/user/Drawer/viewmodel/drawer_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/models/category_model.dart';

class CategoryDrawerItem extends StatefulWidget {
  const CategoryDrawerItem({
    super.key,
    required this.item,
    required this.drawerProvider,
    required this.index,
    required this.numOfCategory,
  });
  final CategoryModel item;
  final DrawerProvider drawerProvider;
  final int numOfCategory;
  final int index;

  @override
  State<CategoryDrawerItem> createState() => _CategoryDrawerItemState();
}

class _CategoryDrawerItemState extends State<CategoryDrawerItem> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await widget.drawerProvider.getSubCategory(categoryId: widget.item.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.drawerProvider.subCategory.length == widget.numOfCategory
        ? ExpansionTile(
            shape: Border.all(color: Colors.transparent),
            collapsedShape: Border.all(color: Colors.transparent),
            backgroundColor: Colors.transparent,
            leading: ClipOval(
              child: CachedNetworkImage(
                imageUrl: "${ApiEndPoints.baseUrl}${widget.item.image}",
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
                width: 50.r,
                height: 50.r,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(widget.item.name),
            children: widget.drawerProvider.subCategory[widget.index]
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
          )
        : Center(
            child: LinearProgressIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.white,
            ),
          );
  }
}
