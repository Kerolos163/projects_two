import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';
import '../constant/image.dart';
import 'search_text_field.dart';
import 'svg_img.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onMenuTap,
    required this.onAvatarTap,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
  });
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback onMenuTap;
  final VoidCallback onAvatarTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: onMenuTap,
                child: SVGImage(path: ImagePath.menuIcon),
              ),
            ),
            Row(
              children: [
                SVGImage(path: ImagePath.appLogo),
                const SizedBox(width: 9),
                Text(
                  "Stylish",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.logoTitleColor,
                    fontFamily: "LibreCaslonText",
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                backgroundImage: AssetImage(ImagePath.avatar),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SearchTextField(
          onTap: onTap,
          readOnly: readOnly,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
