import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/Services/preferences_manager.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Core/models/return_model.dart';
import 'package:projects_two/Core/utils/app_constants.dart';
import 'package:projects_two/Features/admin/returns_dashboard/service/return_service.dart';
import 'package:projects_two/Features/admin/users_dashboard/service/user_service.dart';

class ReturnsDashboardProvider with ChangeNotifier {
  final ReturnService _returnService = ReturnService();

  List<ReturnModel> _returns = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReturnModel> get returns => _returns;
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

  Future<void> fetchAllReturns() async {
    _setLoading(true);
  try {
      final fetchedReturns = await _returnService.getAllReturns();
      _returns = fetchedReturns.reversed.toList();
      for(var returnModel in _returns) {
        returnModel.order!.cust = await UserService.getUserById( returnModel.order!.custId);
      }
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchReturnsForCurrentUser() async {
    _setLoading(true);
    try {
      final userInfo = PreferencesManager.getString(AppConstants.userInfo);
      if (userInfo == null) {
        _setError("User not logged in");
        return;
      }

      final userId = jsonDecode(userInfo)['id'];
      final userReturns = await _returnService.getReturnsByUserId(userId: userId);
      _returns = userReturns.reversed.toList();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createReturnRequest({
    required int orderId,
    required List<ProductModel> products,
    String reason = '',
  }) async {
    _setLoading(true);
    try {
      final userInfo = PreferencesManager.getString(AppConstants.userInfo);
      if (userInfo == null) {
        _setError("User not logged in");
        return false;
      }
      final newReturn = await _returnService.createReturnRequest(orderId: orderId.toString(), products: products.map((p) => {
        'pId': p.id,
      }).toList());
      _returns.insert(0, newReturn);
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<ReturnModel?> getReturnById(String id) async {
    try {
      return await _returnService.getReturnById(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  Future<bool> updateReturnStatus({
    required String returnId,
    required String newStatus,
  }) async {
    _setLoading(true);
    try {
     await _returnService.updateReturnStatus(
        returnId: returnId,
        newStatus: newStatus,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }


}
