import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/Theme/app_provider.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/constant/image.dart';
import 'package:projects_two/Features/user/Home/view/home_screen.dart';
import 'package:provider/provider.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key, required this.onAvatarTap});
  final VoidCallback onAvatarTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          // padding: EdgeInsets.zero,
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
          child: Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return appProvider.state == ApiState.loading
                  ? const CircularProgressIndicator()
                  : CircleAvatar(
                      backgroundImage: appProvider.image != null
                          ? NetworkImage(
                              "${ApiEndPoints.baseUrl}uploads/${appProvider.image}",
                            )
                          : AssetImage(ImagePath.avatar),
                    );
            },
          ),
        ),
      ],
    );
  }
}
