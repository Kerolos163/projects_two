import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../Core/api/api_end_points.dart';

class CustomSliderWidget extends StatefulWidget {
  const CustomSliderWidget({super.key, required this.images});
  final List<String> images;

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  int myCurrentIndex = 0;
  final CarouselSliderController controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                CarouselSlider(
                  items: List.generate(widget.images.length, (index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: '${ApiEndPoints.baseUrl}${widget.images[index]}',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 300,
                      ),
                    );
                  }),
                  carouselController: controller,
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayInterval: Duration(seconds: 6),
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        myCurrentIndex = index;
                      });
                    },
                  ),
                ),
              ],
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
            count: widget.images.length,
            effect: WormEffect(
              dotHeight: 15,
              dotWidth: 15,
              spacing: 8,
              activeDotColor: Color(0xffF83758),
            ),
          ),
        ),
      ],
    );
  }
}
