import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Theme/app_provider.dart';
import '../api/api_end_points.dart';
import '../api/api_state.dart';
import '../constant/app_colors.dart';
import '../constant/image.dart';
import 'search_text_field.dart';
import 'svg_img.dart';

class HomeHeader extends StatefulWidget {
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
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Future.microtask(() => appProvider.getUserImage());
    super.initState();
  }

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
                onTap: widget.onMenuTap,
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
              onTap: widget.onAvatarTap,
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
        ),
        const SizedBox(height: 16),
        SearchTextField(
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
