import 'package:flutter/widgets.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/utils/colorFromCategory.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class PieChartLegend extends StatelessWidget {
  const PieChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.salesByCategory.isEmpty) {
          return const SizedBox.shrink();
        }

    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: provider.salesByCategory.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              color: getColorForCategory(category.category),
            ),
            const SizedBox(width: 8),
            Text(
              '${category.category}: \$${category.totalSales.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  },
    ) ;
  }
}