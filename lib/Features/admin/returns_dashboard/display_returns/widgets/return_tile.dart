import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/models/return_model.dart';
import 'package:projects_two/Features/admin/returns_dashboard/return_details/view/return_details_screen.dart';
import 'package:projects_two/Features/admin/returns_dashboard/viewmodel/return_dashboard_provider.dart';
import 'package:provider/provider.dart';

class ReturnTile extends StatelessWidget {
  final ReturnModel returnRequest;
  final VoidCallback onUpdated;

  const ReturnTile({
    super.key, 
    required this.returnRequest, 
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final status = returnRequest.status ?? '';
    final theme = Theme.of(context);
    final cardColor = _getCardColor(status);
    final borderColor = _getBorderColor(status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
        ),
        child: Consumer<ReturnsDashboardProvider>(
          builder: (context, provider, _) {
            return ListTile(
              leading: _buildProductImage(),
              title: _buildTitleContent(theme),
              trailing: const Icon(Icons.arrow_forward, size: 16),
              onTap: () => _navigateToDetails(context, provider),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = returnRequest.products?.isNotEmpty == true && 
                    returnRequest.products?[0].imageCover != null
        ? '${ApiEndPoints.baseUrl}${returnRequest.products?[0].imageCover}'
        : 'https://via.placeholder.com/56';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      ),
    );
  }

  Widget _buildTitleContent(ThemeData theme) {
    final customerName = returnRequest.order?.cust?.fName ?? 
                         returnRequest.order?.custId ?? 'Unknown Customer';
    final orderId = returnRequest.order!.oId.toString() ;
    final status = returnRequest.status ?? 'Unknown Status';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer: $customerName',
          style: theme.textTheme.displayLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          'Order #: $orderId',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'Status: $status',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Future<void> _navigateToDetails(
    BuildContext context, 
    ReturnsDashboardProvider provider
  ) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: ReturnDetailsScreen(returnRequest: returnRequest),
        ),
      ),
    );
    
    if (updated == true) {
      onUpdated();
    }
  }

  Color _getCardColor(String status) {
    const opacity = 0.05;
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.withOpacity(opacity);
      case 'pending':
        return Colors.yellow.withOpacity(opacity);
      case 'rejected':
        return Colors.red.withOpacity(opacity);
      default:
        return Colors.grey.withOpacity(opacity);
    }
  }

  Color _getBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange; // More visible than yellow
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}