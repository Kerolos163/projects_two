import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
import 'package:projects_two/Features/payment/cart/view/cart_screen.dart';
import '../Theme/app_provider.dart';
import 'package:provider/provider.dart';

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
            Image.asset(
              "assets/image/home_header.png",
              width: 200.w,
              height: 75.h,
            ),
            Row(
              children: [
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
                SizedBox(width: 15),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Cart Icon
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                      child: SVGImage(
                        path: ImagePath.shoppingIcon,
                        color: Theme.of(context).colorScheme.secondary,
                        width: 30,
                      ),
                    ),

                    // Badge
                    Positioned(
                      top: -7,
                      right: -7,
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final count = cartProvider.cartItems.length;
                          if (count == 0) {
                            return SizedBox(); // No badge if count is 0
                          }
                          return Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
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
