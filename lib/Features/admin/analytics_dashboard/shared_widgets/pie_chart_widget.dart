import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/models/monthly_sales_model.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/utils/colorFromCategory.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.salesByCategory.isEmpty) {
          return Center(
            child: Text(
              'No sales data available.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }

        return SfCircularChart(
          title: ChartTitle(
            text: 'Sales Distribution',
            textStyle: const TextStyle(fontSize: 18),
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: const TextStyle(fontSize: 14),
          ),
          series: <CircularSeries>[
            PieSeries<CategorySales, String>(
              dataSource: provider.salesByCategory,
              xValueMapper: (CategorySales sales, _) => sales.category,
              yValueMapper: (CategorySales sales, _) => sales.totalSales,
              dataLabelMapper: (CategorySales sales, _) => sales.category,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition:
                    ChartDataLabelPosition.outside, // Changed to outside
                textStyle: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve,
                  width: 2,
                  color: Colors.black54,
                ),
              ),
              pointColorMapper: (CategorySales sales, _) =>
                  getColorForCategory(sales.category),
              explode: true,
              explodeIndex: 0,
              explodeOffset: '10%',
              radius: '70%',
            ),
          ],
          tooltipBehavior: TooltipBehavior(
            enable: true,
            textStyle: const TextStyle(fontSize: 14),
          ),
        );
      },
    );
  }
}
