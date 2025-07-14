import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../Core/Services/preferences_manager.dart';
import '../../../Core/api/api_end_points.dart';
import '../../../Core/api/api_service.dart';
import '../../../Core/api/api_state.dart';
import '../../../Core/models/user_model.dart';
import '../../../Core/utils/app_constants.dart';
import '../models/forget_password_model.dart';
import '../models/login_model.dart';
import '../models/sign_up_param.dart';

class AuthProvider extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;
  ApiState state = ApiState.initial;
  ApiService apiService = ApiService();
  ForgetPasswordResponse? forgetPasswordResponse;
  late UserModel userModel;
  String errorMessage = '';

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  Future<void> login({required LoginModel loginModel}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.post(
        ApiEndPoints.login,
        body: loginModel.toJson(),
      );
      userModel = UserModel.fromJson(response.data["data"]);
      await PreferencesManager.setString(
        AppConstants.userTokenKey,
        userModel.token,
      );
      await PreferencesManager.setString(
        AppConstants.userInfo,
        jsonEncode(userModel.toJson()),
      );
      state = ApiState.success;
    } catch (error) {
      errorMessage = error.toString();
      log('errorMessage: $errorMessage');
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> signUp({required SignUpParam signUpParam}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.post(
        ApiEndPoints.register,
        body: signUpParam.toJson(),
        isFormData: true,
      );
      userModel = UserModel.fromJson(response.data["data"]);
      await PreferencesManager.setString(
        AppConstants.userTokenKey,
        userModel.token,
      );
      state = ApiState.success;
    } catch (e) {
      errorMessage = e.toString();
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> forgetPassword({required String email}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.post(
        ApiEndPoints.forgotPassword,
        body: {"email": email},
      );
      forgetPasswordResponse = ForgetPasswordResponse.fromJson(response.data);
      state = ApiState.success;
    } catch (error) {
      errorMessage = error.toString();
      log('errorMessage: $errorMessage');
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> verifyPassword({required String resetCode}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.post(
        ApiEndPoints.verifyPassword,
        body: {"resetCode": resetCode},
      );
      log(response.data.toString());
      state = ApiState.success;
    } catch (error) {
      errorMessage = error.toString();
      log('errorMessage: $errorMessage');
      state = ApiState.error;
    }
    notifyListeners();
  }

  Future<void> resetPassword({required LoginModel loginModel}) async {
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.put(
        ApiEndPoints.resetPassword,
        body: loginModel.toJson(),
      );
      log(response.data.toString());
      state = ApiState.success;
    } catch (error) {
      errorMessage = error.toString();
      log('errorMessage: $errorMessage');
      state = ApiState.error;
    }
    notifyListeners();
  }
}
