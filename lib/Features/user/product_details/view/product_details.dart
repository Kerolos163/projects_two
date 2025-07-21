import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/constant/image.dart';
import 'package:projects_two/Core/widgets/svg_img.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
import 'package:projects_two/Features/payment/cart/view/cart_screen.dart';
import '../../../../Core/constant/app_strings.dart';
import 'widgets/actions_row.dart';
import 'widgets/add_review_bottom_sheet.dart';
import 'widgets/pricing_info.dart';
import 'package:provider/provider.dart';
import '../../../../Core/Services/service_locator.dart';
import '../../../../Core/api/api_state.dart';
import '../../../Auth/views/login_screen.dart';
import '../viewmodel/details_provider.dart';
import 'widgets/review_list_view.dart';
import '../../../../Core/widgets/rating_bar_widget.dart';
import '../../../../Core/models/product_model.dart';
import 'widgets/review_section.dart';
import 'widgets/custom_slider.dart';
import 'widgets/product_info.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;

    const ProductDetails({super.key, 
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    log("ProductDetails===>: ${product.id}");
    return ChangeNotifierProvider(
      create: (_) => getIt<DetailsProvider>()
        ..isFavorited(productId: product.id)
        ..getProductReviews(productId: product.id),
      builder: (context, child) => Consumer<DetailsProvider>(
        builder: (context, detailsProvider, child) {
          if (detailsProvider.message == "Invalid token") {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            });
          }

          return detailsProvider.state == ApiState.loading
              ? Center(child: CircularProgressIndicator())
              : PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (!didPop) {
                      Navigator.pop(context, 'refresh');
                    }
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(AppStrings.productDetails.tr()),
                      actions: [
                        IconButton(
                          onPressed: () async {
                            final isAdded = await detailsProvider
                                .changeFavorite(productId: product.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isAdded
                                      ? 'Added to favorites.'
                                      : 'Removed from favorites.',
                                ),
                                backgroundColor: isAdded
                                    ? Colors.green
                                    : Colors.red,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          icon: detailsProvider.isFavorite
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(Icons.favorite_border),
                        ),
                        SizedBox(width: 10),
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
                                width: 25,
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
                        SizedBox(width: 10),
                      ],
                    ),
                    body: SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          CustomSliderWidget(images: [product.imageCover, ...product.images]),
                          SizedBox(height: 20),
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 10),
                          PricingInfo(
                            price: product.price,
                            priceAfterDiscount: product.priceAfterDiscount,
                          ),
                          SizedBox(height: 10),
                          Text(
                            AppStrings.information.tr(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 10),
                          ProductInfo(
                            description: product.description,
                            categoryName: product.category.name,
                          ),
                          SizedBox(height: 20),
                          AddToCartButton(product: product),
                          SizedBox(height: 40),
                          ReviewSection(
                            reviews: detailsProvider.reviews,
                            rating: detailsProvider.productRating,
                          ),
                          RatingBarWidget(
                            initialRating: detailsProvider.productRating,
                          ),
                          Text(
                            detailsProvider.reviews.isEmpty
                                ? AppStrings.noReviewsYet.tr()
                                : detailsProvider.reviews.length.toString(),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 110, 108, 108),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),

                          ReviewListView(
                            list: detailsProvider.reviews,
                            provider: detailsProvider,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              final result = showModalBottomSheet(
                                enableDrag: true,
                                useSafeArea: true,
                                showDragHandle: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => SizedBox(
                                  height: .7.sh,
                                  child: AddReviewBottomSheet(
                                    productId: product.id,
                                    provider: detailsProvider,
                                  ),
                                ),
                              );
                              log("result: $result");
                            },
                            child: Text(AppStrings.addReview.tr()),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
