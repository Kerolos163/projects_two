import 'package:flutter/widgets.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/models/monthly_sales_model.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/service/analytics_dashboard_service.dart';

class AnalyticsDashboardProvider extends ChangeNotifier {
  final AnalyticsService _analyticsService = AnalyticsService();

  List<ProductModel> bestSellers = [];
  List<ProductModel> trendingProducts = [];
  List<MonthlySales> monthlySales = [];
  List<CategorySales> salesByCategory = []; 
  
  bool isLoading = true;
  bool isTrendingLoading = true;
  String? errorMessage;

  Future<void> fetchBestSellers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final products = await _analyticsService.getBestSellers();
      bestSellers = products;
    } catch (e) {
      errorMessage = 'Failed to load best sellers: ${e.toString()}';
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrendingProducts({DateTime? startDate, DateTime? endDate}) async {
    isTrendingLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final products = await _analyticsService.getTrendingProducts(
        startDate: startDate,
        endDate: endDate,
      );
      trendingProducts = products;
    } catch (e) {
      errorMessage = 'Failed to load trending products: ${e.toString()}';
      debugPrint(errorMessage);
    } finally {
      isTrendingLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMonthlySales({int? year, int? month}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

   try {
      final sales = await _analyticsService.getMonthlySales(year: year, month: month);
      monthlySales = sales;
   } catch (e) {
      errorMessage = 'Failed to load monthly sales: ${e.toString()}';
      debugPrint(errorMessage);
   } finally {
      isLoading = false;
      notifyListeners();
   }
  }

  Future<void> fetchSalesByCategory({int? year, int? month}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      salesByCategory = await _analyticsService.getSalesByCategory(year: year, month: month);
    } catch (e) {
      errorMessage = 'Failed to load sales by category: ${e.toString()}';
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}