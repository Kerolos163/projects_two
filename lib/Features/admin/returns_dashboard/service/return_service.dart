import 'dart:convert';

import 'package:projects_two/Core/Services/preferences_manager.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/models/return_model.dart';
import 'package:projects_two/Core/utils/app_constants.dart';

class ReturnService {
  final ApiService _apiService = ApiService();
  final String baseUrl = 'api/returns';

  Future<List<ReturnModel>> getAllReturns() async {
    final response = await _apiService.get(baseUrl);
    List<ReturnModel> returns = [];
    List data = response.data;
    data.forEach((json) {
      returns.add(ReturnModel.fromJson(json));
    });
    return returns;
  }

  Future<ReturnModel> getReturnById(String returnId) async {
    final response = await _apiService.get('$baseUrl/$returnId');
    return ReturnModel.fromJson(response.data['data']);
  }

  Future<ReturnModel> createReturnRequest({
    required String orderId,
    required List<Map<String, dynamic>> products,
  }) async {
    final body = {'orderId': orderId, 'products': products};
    final response = await _apiService.post(baseUrl, body: body);
    return ReturnModel.fromJson(response.data['data']);
  }

  Future<bool> updateReturnStatus({
    required String returnId,
    required String newStatus,
  }) async {
    final response = await _apiService.patch(
      '$baseUrl/$returnId',
      body: {'status': newStatus},
    );
    print('Updated return status: ${response.statusCode}');
    return response.statusCode == 200;
  }

  Future<List<ReturnModel>> getReturnsByUserId({String? userId}) async {

    if (userId == null) {
      String? userInfo = PreferencesManager.getString(AppConstants.userInfo);
      if (userInfo == null) {
        throw Exception("User not logged in");
      }
      userId = jsonDecode(userInfo)['id'];
    }
    final response = await _apiService.get('$baseUrl/user/$userId');

    List data = response.data['data'];
    return data.map((json) => ReturnModel.fromJson(json)).toList();
  }
}
