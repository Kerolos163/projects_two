import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../sales_by_category/view/sales_by_category_screen.dart';
import '../../shared_widgets/pie_chart_legend.dart';
import '../../shared_widgets/pie_chart_widget.dart';
import '../../viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class SalesByCategoryWidget extends StatelessWidget {
  const SalesByCategoryWidget({super.key});

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
             AppStrings.noSalesData.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                   AppStrings.salesByCat.tr(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                            child: SalesByCategoryScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(height: 400, child: PieChartWidget()),
              const SizedBox(height: 20),
              PieChartLegend(),
            ],
          ),
        );
      },
    );
  }
}
