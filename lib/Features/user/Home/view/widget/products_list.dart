import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../Core/models/product_model.dart';
import '../../../product_details/view/product_details.dart';
import '../../data/category_data.dart';

class ProductsList extends StatelessWidget {
  final List<ProductModel> products;
  const ProductsList({super.key, required this.products});
  @override
  Widget build(BuildContext context) {
    log("${products.isEmpty} 🫵");
    return SizedBox(
      height: 360.h,
      child: Skeletonizer(
        enabled: products.isEmpty,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 8,
              childAspectRatio: 1.4,
            ),
            itemCount: products.isEmpty ? fakeProduct.length : products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetails(product: products[index]),
                  ),
                ),
                child: ProductCardHome(
                  productModel: products.isEmpty
                      ? fakeProduct[index]
                      : products[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
