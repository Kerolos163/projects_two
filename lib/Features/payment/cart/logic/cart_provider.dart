import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/api/api_service.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/models/product_model.dart';
import '../../../../Core/models/user_model.dart';
import '../../../../Core/utils/app_constants.dart';

class CartProvider extends ChangeNotifier {
  int _paymentMethodIndex = 0;

  int get paymentMethodIndex => _paymentMethodIndex;

  set paymentMethodIndex(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  ApiState state = ApiState.initial;
  ApiService apiService = ApiService();
  String message = '';
  late UserModel localData;

  final List<ProductModel> _cartItems = [];

  List<ProductModel> get cartItems => _cartItems;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController copon = TextEditingController();

  Map<String, double> couponDiscounts = {
    "cpn5": 0.05,
    "cpn10": 0.10,
    "cpn15": 0.15,
    "cpn20": 0.20,
  };

  Future<void> loadCartData() async {
    await loadCartFromStorage();
    notifyListeners();
  }

  Future<String?> _getUserCartKey() async {
    final userInfo = PreferencesManager.getString(AppConstants.userInfo);
    if (userInfo == null) return null;

    final user = UserModel.fromJson(jsonDecode(userInfo));
    return 'cart_${user.id}';
  }

  Future<void> loadCartFromStorage() async {
    state = ApiState.loading;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserCartKey();
      if (key == null) {
        state = ApiState.error;
        return;
      }

      final cartString = prefs.getString(key);
      if (cartString != null) {
        final List decoded = jsonDecode(cartString);
        _cartItems.clear();
        _cartItems.addAll(decoded.map((item) => ProductModel.fromJson(item)));
      } else {
        _cartItems.clear();
      }

      state = ApiState.success;
    } catch (e) {
      state = ApiState.error;
    }

    notifyListeners();
  }

  Future<void> saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserCartKey();
    if (key == null) return;

    final cartJson = _cartItems.map((product) => product.toJson()).toList();
    await prefs.setString(key, jsonEncode(cartJson));
  }

  Future<void> removeFromCart(ProductModel product) async {
    _cartItems.removeWhere((item) => item.id == product.id);
    await saveCartToStorage();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserCartKey();
    if (key != null) {
      await prefs.remove(key);
    }
    notifyListeners();
  }

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get finalPrice {
    if (copon.text.isEmpty) {
      return totalPrice;
    }
    String enteredCoupon = copon.text.trim().toLowerCase();
    double discountRate = couponDiscounts[enteredCoupon] ?? 0.0;
    return totalPrice * (1 - discountRate);
  }

  void increaseQuantity(ProductModel product) {
    final index = _cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
      saveCartToStorage();
      notifyListeners();
    }
  }

  void decreaseQuantity(ProductModel product) {
    final index = _cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index] = _cartItems[index].copyWith(
          quantity: _cartItems[index].quantity - 1,
        );
      } else {
        _cartItems.removeAt(index);
      }
      saveCartToStorage();
      notifyListeners();
    }
  }

  Future<void> addNewOrder({required String paymentMethod}) async {
    state = ApiState.loading;
    notifyListeners();

    try {
      List<Map<String, dynamic>> products = _cartItems
          .map((e) => {"pId": e.id, "quantity": e.quantity})
          .toList();
      String userInfo = PreferencesManager.getString(AppConstants.userInfo)!;
      localData = UserModel.fromJson(jsonDecode(userInfo));

      final response = await apiService.post(
        ApiEndPoints.orders,
        body: {
          "custId": localData.id,
          "address": address.text,
          "city": city.text,
          "paymentMethod": paymentMethod,
          "products": products,
          "copon": copon.text.isNotEmpty ? copon.text : "non",
          "price": finalPrice,
        },
      );

      message = response.data["message"];
      state = ApiState.success;
    } catch (err) {
      log('error: $err');
      message = err.toString();
      state = ApiState.error;
    }

    notifyListeners();
  }

  Future<void> addToCart(ProductModel product) async {
    await loadCartFromStorage();
    final existingIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
    } else {
      _cartItems.add(product.copyWith(quantity: 1));
    }
    await saveCartToStorage();
    notifyListeners();
  }
}
