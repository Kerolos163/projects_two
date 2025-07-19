import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/models/monthly_sales_model.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/shared_widgets/chart_widget.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class MonthlySalesScreen extends StatefulWidget {
  const MonthlySalesScreen({super.key});

  @override
  State<MonthlySalesScreen> createState() => _MonthlySalesScreenState();
}

class _MonthlySalesScreenState extends State<MonthlySalesScreen> {
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
    await provider.fetchMonthlySales(
      year: _selectedYear,
      month: _selectedYear != null ? _selectedMonth : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<AnalyticsDashboardProvider>().fetchMonthlySales();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Monthly Sales').tr()),
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
                          const Text('Filter by:').tr(),
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
                                    labelText: 'Year'.tr(),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ), // Added padding
                                  ),
                                  items: [
                                    DropdownMenuItem<int?>(
                                      value: null,
                                      child: const Text('All time').tr(),
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
                                    labelText: 'Month'.tr(),
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
                                            child: const Text(
                                              'All months',
                                            ).tr(),
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
                                          }).toList(),
                                        ],
                                  onChanged: _selectedYear == null
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedMonth = value;
                                          });
                                        },
                                  disabledHint: const Text(
                                    'Select a year first',
                                  ).tr(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _fetchData,
                              child: const Text('Apply Filters').tr(),
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
                        'No monthly sales data found.'.tr(),
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
                                      ? 'All Time Sales'.tr()
                                      : _selectedMonth == null
                                      ? '${_selectedYear} Sales'.tr()
                                      : '${DateFormat('MMMM yyyy').format(DateTime(_selectedYear!, _selectedMonth!))} Sales'
                                            .tr(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                const ChartWidget(),
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
                                  'Detailed Data'.tr(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                _buildDataTable(provider.monthlySales, context),
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

 Widget _buildDataTable(List<MonthlySales> data, BuildContext context) {
  // Calculate total sales and revenue
  final totalSales = data.fold<int>(0, (sum, sale) => sum + sale.totalSales);
  final totalRevenue =
      data.fold<double>(0.0, (sum, sale) => sum + sale.totalRevenue);

  final dataRows = data.map((sale) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            DateFormat('MMMM yyyy').format(DateTime(sale.year, sale.month)),
          ),
        ),
        DataCell(Text(sale.totalSales.toString())),
        DataCell(Text('\$${sale.totalRevenue.toStringAsFixed(2)}')),
      ],
    );
  }).toList();

  // Add summary row
  dataRows.add(
    DataRow(
      color: MaterialStateProperty.all(
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
      ),
      cells: [
        DataCell(Text(
          'Total'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          totalSales.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          '\$${totalRevenue.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
      ],
    ),
  );

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columnSpacing: 24,
      columns: [
        DataColumn(
          label: Text(
            'Month'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        DataColumn(
          label: Text(
            'Sales'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Revenue'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          numeric: true,
        ),
      ],
      rows: dataRows,
    ),
  );
}
}
