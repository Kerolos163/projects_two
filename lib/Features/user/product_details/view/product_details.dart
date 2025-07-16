import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/user/product_details/view/widgets/actions_row.dart';
import 'package:projects_two/Features/user/product_details/view/widgets/pricing_info.dart';
import 'package:provider/provider.dart';
import '../../../../Core/Services/service_locator.dart';
import '../../../../Core/api/api_state.dart';
import '../viewmodel/details_provider.dart';
import 'user_review_card.dart';
import '../../../../Core/widgets/rating_bar_widget.dart';
import '../../../../Core/models/product_model.dart';
import 'review_section.dart';
import 'widgets/custom_slider.dart';
import 'widgets/product_info.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;

  const ProductDetails({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<DetailsProvider>()
        ..isFavorited(productId: product.id)
        ..getProductReviews(productId: product.id),
      builder: (context, child) => Consumer<DetailsProvider>(
        builder: (context, detailsProvider, child) {
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
                          onPressed: () => detailsProvider.changeFavorite(
                            productId: product.id,
                          ),
                          icon: detailsProvider.isFavorite
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Color(0xff323232),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    body: SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          CustomSliderWidget(images: product.imageCover),
                          SizedBox(height: 20),
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 20),
                          PricingInfo(
                            price: product.price,
                            priceAfterDiscount: product.priceAfterDiscount,
                          ),
                          SizedBox(height: 20),
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
                          ActionsRow(),
                          SizedBox(height: 40),
                          ReviewSection(
                            rating: double.parse(product.ratingsAverage),
                          ),
                          RatingBarWidget(
                            initialRating: double.parse(product.ratingsAverage),
                          ),
                          Text(
                            product.ratingsQuantity.toString(),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 110, 108, 108),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 30),
                          UserReviewCard(),
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
