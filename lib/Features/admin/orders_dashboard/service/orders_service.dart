import 'dart:convert';
import 'package:projects_two/Core/Services/preferences_manager.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/models/order_model.dart';
import 'package:projects_two/Core/utils/app_constants.dart';

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
}
