import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/monthly_sales/views/monthly_sales_screen.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/shared_widgets/chart_widget.dart';
import 'package:provider/provider.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';

class MonthlySalesWidget extends StatelessWidget {
  const MonthlySalesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.monthlySales.isEmpty) {
          return Center(
            child: Text(
              'No monthly sales data found.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Text(
                    'Monthly Sales',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_circle_right_sharp,
                    color: AppColors.primaryButton,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: provider,
                          child: MonthlySalesScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ChartWidget(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
