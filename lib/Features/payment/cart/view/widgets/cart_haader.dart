import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/image.dart';
import '../../../../../Core/widgets/svg_img.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({
    super.key,
    required this.onMenuTap,
    required this.onAvatarTap,
  });
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
            Text(
              "My Cart",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                // color: AppColors.logoTitleColor,
                fontFamily: "LibreCaslonText",
              ),
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
      ],
    );
  }
}
