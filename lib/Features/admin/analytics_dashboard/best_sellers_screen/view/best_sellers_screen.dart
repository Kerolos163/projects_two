import 'package:flutter/material.dart';
import '../../shared_widgets/large_product_card.dart';
import '../../viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class BestSellersScreen extends StatelessWidget {
  const BestSellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Best Sellers')),
      body: Consumer<AnalyticsDashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bestSellers.isEmpty) {
            return Center(
              child: Text(
                'No best sellers found.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: provider.bestSellers.length,
              itemBuilder: (context, index) {
                final product = provider.bestSellers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: LargeProductCard(product: product),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
