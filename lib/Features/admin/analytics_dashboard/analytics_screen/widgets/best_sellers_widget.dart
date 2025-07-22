import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'product_card.dart';
import '../../best_sellers_screen/view/best_sellers_screen.dart';
import '../../viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class BestSellersWidget extends StatelessWidget {
  const BestSellersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AnalyticsDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.bestSellers.isEmpty) {
          return Center(
            child: Text(
              AppStrings.noBestSellersAvaliable.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          );
        }

        final displayedProducts = provider.bestSellers.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                   AppStrings.bestSellers.tr(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_right_sharp),
                    color: theme.colorScheme.primary,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: provider,
                            child: const BestSellersScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: displayedProducts.length + 1,
                itemBuilder: (context, index) {
                  if (index == displayedProducts.length) {
                    // This is the "View More" card
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return ChangeNotifierProvider.value(
                                  value: provider,
                                  child: const BestSellersScreen(),
                                );
                              },
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: theme.colorScheme.primaryContainer,
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  size: 32,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.viewAll.tr(),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final product = displayedProducts[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == displayedProducts.length - 1 ? 0 : 8.0,
                    ),
                    child: AnalyticsProductCard(product: product),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
