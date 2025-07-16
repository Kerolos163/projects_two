import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Core/Services/service_locator.dart';
import '../../../../Core/api/api_state.dart';
import '../viewmodel/details_provider.dart';
import 'user_review_card.dart';
import '../../../../Core/widgets/rating_bar_widget.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/constant/app_colors.dart';
import '../../../../Core/models/product_model.dart';
import 'review_section.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int myCurrentIndex = 0;
  final CarouselSliderController controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<DetailsProvider>()
        ..isFavorited(productId: widget.product.id)
        ..getProductReviews(productId: widget.product.id),
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
                      title: Text("Product Details"),
                      actions: [
                        IconButton(
                          onPressed: () => detailsProvider.changeFavorite(
                            productId: widget.product.id,
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
                    body: SingleChildScrollView(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CarouselSlider(
                                    items: List.generate(5, (_) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${ApiEndPoints.baseUrl}${widget.product.imageCover}',
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          height: 300,
                                        ),
                                      );
                                    }),
                                    carouselController: controller,
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      autoPlayAnimationDuration: Duration(
                                        milliseconds: 800,
                                      ),
                                      autoPlayInterval: Duration(seconds: 2),
                                      enlargeCenterPage: true,
                                      aspectRatio: 2.0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          myCurrentIndex = index;
                                        });
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffF83758),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          controller.previousPage();
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffF83758),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          controller.nextPage();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: AnimatedSmoothIndicator(
                                  activeIndex: myCurrentIndex,
                                  count: 5,
                                  effect: WormEffect(
                                    dotHeight: 15,
                                    dotWidth: 15,
                                    spacing: 8,
                                    activeDotColor: Color(0xffF83758),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                widget.product.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    widget.product.price.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Color(0xff808488),
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.product.price.toString(),
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.product.priceAfterDiscount
                                        .toString(),
                                    style: TextStyle(
                                      color: Color(0xffFA7189),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Product details",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.product.description,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Category:  ${widget.product.category.name}',
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.shopping_cart),
                                    label: Text(
                                      "Add to cart",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: AppColors.primaryButton,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.attach_money,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Buy now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 4,
                                      backgroundColor: AppColors.primaryButton,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              ReviewSection(
                                rating: double.parse(
                                  widget.product.ratingsAverage,
                                ),
                              ),
                              RatingBarWidget(
                                initialRating: double.parse(
                                  widget.product.ratingsAverage,
                                ),
                              ),
                              Text(
                                widget.product.ratingsQuantity.toString(),
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    110,
                                    108,
                                    108,
                                  ),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 30),
                              UserReviewCard(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
