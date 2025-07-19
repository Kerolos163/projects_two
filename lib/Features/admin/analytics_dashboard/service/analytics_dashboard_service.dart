import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Features/admin/analytics_dashboard/models/monthly_sales_model.dart';

class AnalyticsService {
  final ApiService _apiService = ApiService();
  final String baseUrl = 'api/analytics';

  Future<List<ProductModel>> getBestSellers() async {
    final response = await _apiService.get('$baseUrl/best-sellers');
    List<ProductModel> products = [];

    for (var item in response.data['data']) {
        // print(item);
        products.add(ProductModel.fromJson(item));
      
    }
    return products;
  }

  Future<List<ProductModel>> getTrendingProducts({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 10,
  }) async {
    final params = {
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
      'limit': limit.toString(),
    };

    List<ProductModel> products = [];
    final response = await _apiService.get(
      '$baseUrl/trending',
      queryParameters: params,
    );

    for (var item in response.data['data']) {
    
       products.add(ProductModel.fromJson(item));
      
      
    }
    return products;
  }

  Future<List<MonthlySales>> getMonthlySales({
    int? year,
    int? month,
  }) async {
    final params = {
      if (year != null) 'year': year.toString(),
      if (month != null) 'month': month.toString(),
    };

    final response = await _apiService.get(
      '$baseUrl/monthly-sales',
      queryParameters: params,
    );
    List<MonthlySales> monthlySales = [];
    for(var item in response.data['data']) {
      monthlySales.add(MonthlySales.fromJson(item));
    }

    return monthlySales;
  }

  // Get sales by category (optionally filtered by year/month)
  Future<List<CategorySales>> getSalesByCategory({
    int? year,
    int? month,

  }) async {
    final params = {
      if (year != null) 'year': year.toString(),
      if (month != null) 'month': month.toString(),
    };
    List<CategorySales> categorySales = [];
    final response = await _apiService.get(
      '$baseUrl/sales-by-category',
      queryParameters: params,
    );
    for (var item in response.data['data']) {
      categorySales.add(CategorySales.fromJson(item));
    }
    return categorySales;
  }

  
}
