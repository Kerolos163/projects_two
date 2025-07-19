import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/analytics_screen/widgets/best_sellers_widget.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/analytics_screen/widgets/monthly_sales_widget.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/analytics_screen/widgets/sales_by_category_widget.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/analytics_screen/widgets/trending_products.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AnalyticsDashboardProvider>();
      provider.fetchBestSellers();
      provider.fetchTrendingProducts();
      provider.fetchMonthlySales();
      provider.fetchSalesByCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsDashboardProvider>(
      builder: (context, provider, _) => Scaffold(
        appBar: AppBar(title: Text('Analytics Dashboard', style: Theme.of(context).textTheme.titleLarge), ),
        body: provider.isLoading || provider.isTrendingLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    MonthlySalesWidget(),
                    SizedBox(height: 16),
                    BestSellersWidget(),
                    SizedBox(height: 16),
                    SalesByCategoryWidget(),
                    SizedBox(height: 16),
                    TrendingProducts(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}
