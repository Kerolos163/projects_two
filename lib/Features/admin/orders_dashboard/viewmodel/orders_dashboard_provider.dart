import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/models/order_model.dart';
import '../../../../Core/utils/app_constants.dart';
import '../service/orders_service.dart';
import '../../products_dashboard/service/dashboard_products_service.dart';
import '../../users_dashboard/service/user_service.dart';

class OrdersDashboardProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchAllOrders() async {
    _setLoading(true);
   try {
      final fetchedOrders = await _orderService.getAllOrders();
      _orders = await _populateOrderDetails(fetchedOrders);
      _orders = _orders.reversed.toList();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      notifyListeners();
      _setLoading(false);
    }
  }

  Future<void> fetchOrdersForCurrentUser() async {
    _setLoading(true);
    try {
      final userOrders = await _orderService.getOrdersByUserId();
      _orders = await _populateOrderDetails(userOrders);
      _orders = _orders.reversed.toList();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<OrderModel?> getOrderById(int oId) async {
    try {
      return await _orderService.getOrderById(oId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  Future<void> loadAllOrderData(OrderModel order) async {
    try {
      for (var product in order.products) {
        product.product = await ProductService().getProduct(product.pId);
      }
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> addNewOrder(OrderModel order) async {
    _setLoading(true);
    try {
      final newOrder = await _orderService.createOrder(order);
      _orders.insert(0, newOrder);
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createOrder({
    required String paymentMethod,
    required List<Map<String, dynamic>> products,
    String status = "pending",
  }) async {
    _setLoading(true);
    try {
      final userInfo = PreferencesManager.getString(AppConstants.userInfo);
      if (userInfo == null) {
        _setError("User not logged in");
        return;
      }

      final userId = jsonDecode(userInfo)['id'];
      final orderProducts = products.map((p) {
        return OrderProduct(
          pId: p['pId'],
          quantity: int.parse(p['quantity'].toString()),
        );
      }).toList();

      final newOrder = OrderModel(
        custId: userId,
        paymentMethod: paymentMethod,
        status: status,
        products: orderProducts,
      );

      final createdOrder = await _orderService.createOrder(newOrder);
      _orders.insert(0, createdOrder);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateOrder(int oId, OrderModel order) async {
    _setLoading(true);
    try {
      final updated = await _orderService.updateOrder(oId, order);
      final index = _orders.indexWhere((o) => o.oId == oId);
      if (index != -1) _orders[index] = updated;
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteOrder(int oId) async {
    _setLoading(true);
    try {
      await _orderService.deleteOrder(oId);
      _orders.removeWhere((order) => order.oId == oId);
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateOrderStatus({
    required int orderId,
    required String newStatus,
    required String email,
  }) async {
    _setLoading(true);
    try {
      final success = await _orderService.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
        email: email,
      );
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<OrderModel>> _populateOrderDetails(List<OrderModel> orders) async {
    for (var order in orders) {
    
      order.cust = await UserService.getUserById(order.custId);
    }
    return orders;
  }
}
