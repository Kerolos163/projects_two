import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import '../../shared_widgets/pie_chart_legend.dart';
import '../../shared_widgets/pie_chart_widget.dart';
import '../../viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class SalesByCategoryScreen extends StatefulWidget {
  const SalesByCategoryScreen({super.key});

  @override
  State<SalesByCategoryScreen> createState() => _SalesByCategoryScreenState();
}

class _SalesByCategoryScreenState extends State<SalesByCategoryScreen> {
  int? _selectedYear;
  int? _selectedMonth;
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedMonth = _currentDate.month;
  }

  Future<void> _fetchData() async {
    final provider = Provider.of<AnalyticsDashboardProvider>(
      context,
      listen: false,
    );
    await provider.fetchSalesByCategory(
      year: _selectedYear,
      month: _selectedYear != null ? _selectedMonth : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<AnalyticsDashboardProvider>().fetchSalesByCategory();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.salesByCat.tr())),
        body: Consumer<AnalyticsDashboardProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter controls
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(AppStrings.filter.tr()),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Year Dropdown with "All time" option
                              Flexible(
                                // Changed from Expanded to Flexible
                                flex: 1,
                                child: DropdownButtonFormField<int?>(
                                  isExpanded:
                                      true, // Added to handle text overflow
                                  value: _selectedYear,
                                  decoration: InputDecoration(
                                    labelText: AppStrings.year.tr(),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ), // Added padding
                                  ),
                                  items: [
                                    DropdownMenuItem<int?>(
                                      value: null,
                                      child:  Text(AppStrings.allTime.tr()),
                                    ),
                                    ...List.generate(
                                      _currentDate.year - 2025 + 1,
                                      (index) => 2025 + index,
                                    ).map((year) {
                                      return DropdownMenuItem<int?>(
                                        value: year,
                                        child: Text(
                                          year.toString(),
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedYear = value;
                                      if (_selectedYear != null) {
                                        _selectedMonth =
                                            _selectedYear == _currentDate.year
                                            ? _currentDate.month
                                            : null;
                                      } else {
                                        _selectedMonth = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8), // Reduced spacing
                              // Month Dropdown with "All" option
                              Flexible(
                                // Changed from Expanded to Flexible
                                flex: 1,
                                child: DropdownButtonFormField<int?>(
                                  isExpanded:
                                      true, // Added to handle text overflow
                                  value: _selectedMonth,
                                  decoration: InputDecoration(
                                    labelText: AppStrings.month.tr(),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ), // Added padding
                                  ),
                                  items: _selectedYear == null
                                      ? null
                                      : [
                                          DropdownMenuItem<int?>(
                                            value: null,
                                            child:  Text(
                                            AppStrings.allMonths.tr()
                                            )
                                          ),
                                          ...List.generate(
                                            _selectedYear == _currentDate.year
                                                ? _currentDate.month
                                                : 12,
                                            (index) => index + 1,
                                          ).map((month) {
                                            return DropdownMenuItem<int?>(
                                              value: month,
                                              child: Text(
                                                DateFormat(
                                                  'MMMM',
                                                ).format(DateTime(2020, month)),
                                                overflow: TextOverflow
                                                    .ellipsis, // Handle overflow
                                              ),
                                            );
                                          })
                                        ],
                                  onChanged: _selectedYear == null
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedMonth = value;
                                          });
                                        },
                                  disabledHint:  Text(
                                    AppStrings.selectAYearFirst.tr()
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _fetchData,
                              child:  Text(AppStrings.applyFilters.tr()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Data visualization
                  if (provider.monthlySales.isEmpty)
                    Center(
                      child: Text(
                        AppStrings.noSalesForCategory.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  _selectedYear == null
                                      ? AppStrings.allTimeSales.tr()
                                      : _selectedMonth == null
                                      ? '${_selectedYear} ${AppStrings.sales.tr()}'
                                      : '${DateFormat('MMMM yyyy').format(DateTime(_selectedYear!, _selectedMonth!))} ${AppStrings.sales.tr()}'
                                            .tr(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                const PieChartWidget(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                 AppStrings.salesByCat.tr(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                 PieChartLegend()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}
