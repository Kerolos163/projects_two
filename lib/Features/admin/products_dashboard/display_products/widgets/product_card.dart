import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_image.dart';
import 'product_title.dart';
import '../../viewmodel/products_dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../Core/models/product_model.dart';
import '../../product_details/view/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ProductsDashboardProvider provider;

  const ProductCard({super.key, required this.product, required this.provider});

  void _onTap(BuildContext context) async {
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          provider.getCategories();
          provider.getSubCategories(product.category.id);
          provider.selectedCategory = product.category.id;
          provider.selectedSubCategory = product.subCategories.isNotEmpty
              ? product.subCategories.first
              : null;
          return ChangeNotifierProvider.value(
            value: provider,
            child: ProductDetailsScreen(product: product),
          );
        },
      ),
    );

    if (shouldRefresh == true && context.mounted) {
      await provider.fetchAllProducts(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductImage(imageUrl: product.imageCover),
            ProductTitle(title: product.title),
          ],
        ),
      ),
    );
  }
}
