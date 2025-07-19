
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/api/api_end_points.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      child: SizedBox(
        height: 173.h,
        child: Image.network(
          '${ApiEndPoints.baseUrl}$imageUrl',
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator(strokeWidth: 2.w));
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(Icons.broken_image, size: 48.sp, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}

