import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/shared_widgets/large_product_card.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/viewmodel/analytics_dashboard_provider.dart';
import 'package:provider/provider.dart';

class TrendingProductsScreen extends StatefulWidget {
  const TrendingProductsScreen({super.key});

  @override
  State<TrendingProductsScreen> createState() => _TrendingProductsScreenState();
}

class _TrendingProductsScreenState extends State<TrendingProductsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      selectableDayPredicate: (DateTime date) {
        return date.isBefore(DateTime.now().add(const Duration(days: 1))) &&
            date.year >= 2025;
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime(2025),
      lastDate: DateTime.now(),
      selectableDayPredicate: (DateTime date) {
        return date.isBefore(DateTime.now().add(const Duration(days: 1))) &&
            (_startDate == null || !date.isBefore(_startDate!));
      },
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _fetchTrendingProducts() {
    if (_startDate != null && _endDate != null) {
      Provider.of<AnalyticsDashboardProvider>(
        context,
        listen: false,
      ).fetchTrendingProducts(startDate: _startDate!, endDate: _endDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<AnalyticsDashboardProvider>().fetchTrendingProducts();
          
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Trending Products')),
        body: Column(
          children: [
            // Date Range Selector
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date Range',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              _startDate == null
                                  ? 'Select Start Date'
                                  : _dateFormat.format(_startDate!),
                            ),
                            onPressed: () => _selectStartDate(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              _endDate == null
                                  ? 'Select End Date'
                                  : _dateFormat.format(_endDate!),
                            ),
                            onPressed: _startDate == null
                                ? null
                                : () => _selectEndDate(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('Get Trending Products'),
                        onPressed: _startDate == null || _endDate == null
                            ? null
                            : _fetchTrendingProducts,
                      ),
                    ),
                    if (_startDate != null && _endDate != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Showing data from ${_dateFormat.format(_startDate!)} to ${_dateFormat.format(_endDate!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Results
            Expanded(
              child: Consumer<AnalyticsDashboardProvider>(
                builder: (context, provider, _) {
                  if (provider.isTrendingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.trendingProducts.isEmpty) {
                    return Center(
                      child: Text(
                        _startDate == null || _endDate == null
                            ? 'Please select a date range'
                            : 'No trending products found for selected dates',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: provider.trendingProducts.length,
                      itemBuilder: (context, index) {
                        final product = provider.trendingProducts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: LargeProductCard(
                            product: product,
                            isBestSeller: false,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
