import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Product/viewmodel/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../Core/Theme/app_provider.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../../../../Core/constant/image.dart';
import '../../../../../Core/widgets/svg_img.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.appProvider});
  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: appProvider.currentIndex,
      onTap: (value) {
        if (value == 1) {
          Provider.of<ProductProvider>(context, listen: false).getProducts();
        }
        appProvider.changeIndex(index: value);
      },
      items: [
        BottomNavigationBarItem(
          icon: SVGImage(
            path: ImagePath.homeIcon,
            color: appProvider.currentIndex == 0
                ? AppColors.primary
                : Theme.of(context).colorScheme.secondary,
          ),
          label: AppStrings.home.tr(),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.style_outlined,
            size: 30.r,
            color: appProvider.currentIndex == 1
                ? AppColors.primary
                : Theme.of(context).colorScheme.secondary,
          ),
          label: AppStrings.products.tr(),
        ),
        BottomNavigationBarItem(
          icon: SVGImage(
            path: ImagePath.heartIcon,
            color: appProvider.currentIndex == 2
                ? AppColors.primary
                : Theme.of(context).colorScheme.secondary,
          ),
          label: AppStrings.favorites.tr(),
        ),
        BottomNavigationBarItem(
          icon: SVGImage(
            path: ImagePath.settingsIcon,
            color: appProvider.currentIndex == 3
                ? AppColors.primary
                : Theme.of(context).colorScheme.secondary,
          ),

          label: AppStrings.profile2.tr(),
        ),
      ],
    );
  }
}
