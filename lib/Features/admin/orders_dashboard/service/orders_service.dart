import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/api/api_service.dart';
import '../../../../Core/models/order_model.dart';
import '../../../../Core/models/return_model.dart';
import '../../../../Core/utils/app_constants.dart';

class OrderService {
  final ApiService _apiService = ApiService();
  final String baseUrl = 'api/orders';

  Future<List<OrderModel>> getAllOrders() async {
    final response = await _apiService.get(baseUrl);
    List data = response.data;
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<OrderModel> getOrderById(int oId) async {
    final response = await _apiService.get('$baseUrl/$oId');
    return OrderModel.fromJson(response.data);
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    final response = await _apiService.post(
      baseUrl,
      body: order.toJson(),
    );
    return OrderModel.fromJson(response.data['data']);
  }

  Future<OrderModel> updateOrder(int oId, OrderModel order) async {
    final response = await _apiService.put(
      '$baseUrl/$oId',
      body: order.toJson(),
    );
    return OrderModel.fromJson(response.data);
  }

  Future<void> deleteOrder(int oId) async {
    await _apiService.delete('$baseUrl/$oId');
  }

  Future<bool> updateOrderStatus({
    required int orderId,
    required String newStatus,
    required String email,
  }) async {
    final response = await _apiService.patch(
      '$baseUrl/status',
      body: {
        'orderId': orderId,
        'newStatus': newStatus,
        'email': email,
      },
    );
    return response.statusCode == 200;
  }

  Future<List<OrderModel>> getOrdersByUserId() async {
    String? userInfo = PreferencesManager.getString(AppConstants.userInfo);
    if (userInfo == null) {
      throw Exception("User not logged in");
    }

    final userId = jsonDecode(userInfo)['id'];
    final response = await _apiService.get('$baseUrl/user/$userId');

    List data = response.data;
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }
  Future<List<ReturnModel>> getReturnsByUserId(String userId) async {
    final dio = Dio();
    final url = '${ApiEndPoints.baseUrl}api/returns';

    try {
      print("🌐 Hitting GET $url without query params");

      final response = await dio.get(url);

      print("🌐 Response status: ${response.statusCode}");
      print("🌐 Response data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          // Filter by userId (custId inside orderId)
          final filteredData = data.where((item) {
            if (item is Map<String, dynamic>) {
              final order = item['orderId'];
              if (order is Map<String, dynamic>) {
                return order['custId'] == userId;
              }
            }
            return false;
          }).toList();

          print("✅ Filtered to ${filteredData.length} return items for user $userId");

          // Map filtered JSON objects to ReturnModel instances
          return filteredData.whereType<Map<String, dynamic>>().map((item) {
            return ReturnModel.fromJson(item);
          }).toList();
        } else {
          throw Exception("Expected a list, got: $data");
        }
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Dio exception: $e");
      throw Exception("Error fetching returns: $e");
    }
  }




}
