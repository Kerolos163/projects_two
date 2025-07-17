import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_end_points.dart';

class ProductImagePreview extends StatelessWidget {
  final String imageUrl;

  const ProductImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        '${ApiEndPoints.baseUrl}$imageUrl',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}
