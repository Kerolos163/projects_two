import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Core/constant/image.dart';
import 'package:projects_two/Core/widgets/svg_img.dart';
import 'package:projects_two/Features/user/Home/view/home_screen.dart';
import 'package:projects_two/Features/user/Home/viewmodel/home_provider.dart';
import 'package:provider/provider.dart';
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
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              },
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
