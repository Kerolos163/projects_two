import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/models/user_model.dart';

import '../../../Core/Services/preferences_manager.dart';
import '../../../Core/utils/app_constants.dart';
import '../model/update_model.dart';

class ProfileProvider extends ChangeNotifier {
  bool update = false;
  ApiService apiService = ApiService();
  ApiState state = ApiState.initial;
  late UserModel userModel;
  late UserModel localData;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  Future<void> getUserInfo() async {
    String userInfo = PreferencesManager.getString(AppConstants.userInfo)!;
    localData = UserModel.fromJson(jsonDecode(userInfo));

    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(
        ApiEndPoints.getUserbyId(id: localData.id),
      );
      userModel = UserModel.fromJson(response.data["data"]);
      initeController();
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }

  initeController() {
    firstNameController = TextEditingController(text: userModel.fName);
    lastNameController = TextEditingController(text: userModel.lName);
    emailController = TextEditingController(text: userModel.email);
    addressController = TextEditingController(text: userModel.address);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void setUpdateValue(bool value) {
    update = value;
    notifyListeners();
  }

  Future<void> updateUser() async {
    state = ApiState.loading;
    notifyListeners();
    try {
      UpdateModel updateModel = UpdateModel(
        fName: firstNameController.text,
        lName: lastNameController.text,
        address: addressController.text,
        email: emailController.text,
        password: passwordController.text == ""
            ? null
            : passwordController.text,
      );
      await apiService.patch(
        ApiEndPoints.updateUserbyId(id: localData.id),
        body: updateModel.toJson(),
      );
      getUserInfo();
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }
}
