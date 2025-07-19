import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<AnalyticsDashboardProvider>(
      builder: (context, provider, _) {
    
        final chartData = provider.monthlySales.map((sale) {
          return _ChartData(
            month: DateFormat('MMM').format(DateTime(2020, sale.month)),
            sales: sale.totalSales.toDouble(),
            revenue: sale.totalRevenue.toDouble(),
          );
        }).toList();

   return   SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  numberFormat: NumberFormat.compact(),
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  BarSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.month,
                    yValueMapper: (_ChartData data, _) => data.sales,
                    name: 'Sales Count',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            );
      },
    );
  }
}
class _ChartData {
  final String month;
  final double sales;
  final double revenue;

  _ChartData({required this.month, required this.sales, required this.revenue});
}
