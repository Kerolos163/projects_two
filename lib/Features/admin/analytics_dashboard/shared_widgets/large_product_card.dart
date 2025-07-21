import 'package:flutter/material.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/models/product_model.dart';
import '../../products_dashboard/product_details/view/product_details_screen.dart';

class LargeProductCard extends StatelessWidget {
  final ProductModel product;
 final bool isBestSeller;
  const LargeProductCard({super.key, required this.product,  this.isBestSeller = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context)
          => ProductDetailsScreen(product: product))),
      },
      child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                color: colorScheme.surfaceVariant,
                child: Image.network(
                  "${ApiEndPoints.baseUrl}${product.imageCover}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              // Best Seller Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isBestSeller ? 'Best Seller' : 'Trending',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Category
                Text(
                  product.title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                ...[
                  const SizedBox(height: 4),
                  Text(
                    product.category.name,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Price and Rating Row
                Row(
                  children: [
                    // Price
                    Text(
                      '\$${product.price}',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                      ],
                ),

                const SizedBox(height: 12),

                // Sales and Stock Information
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      icon: Icons.shopping_bag,
                      value: '${product.sold} sold',
                    ),
                    const SizedBox(width: 12),
                 
                      _buildInfoChip(
                        context,
                        icon: Icons.inventory,
                        value: '${product.quantity} in stock',
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Description (if available)
             
                  Text(
                    product.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}