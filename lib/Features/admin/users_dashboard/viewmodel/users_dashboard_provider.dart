import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/models/user_model.dart';
import 'package:projects_two/Features/admin/users_dashboard/service/user_service.dart';

class UserDashboardProvider extends ChangeNotifier {
  List<UserModel> users = [];
  ApiState apiState = ApiState.initial;
  String? errorMessage;

  /// Fetch all users
  Future<void> fetchUsers() async {
    apiState = ApiState.loading;
    notifyListeners();

   try {

      users.clear();
      users = await UserService.getAllUsers();
      if (users.isNotEmpty) {
      } else {
      }
      if (users.isEmpty) {
        errorMessage = "No users found";
      } else {
        errorMessage = null;
      }
      apiState = ApiState.success;
    } catch (e) {
      errorMessage = e.toString();
      apiState = ApiState.error;
    }

    notifyListeners();
  }

  /// Update user
  Future<bool> updateUser({required String id, required UserModel user}) async {
    apiState = ApiState.loading;
    notifyListeners();

    try {
      final updatedUser = await UserService.updateUser(id: id, user: user);

      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = updatedUser;
      }

      apiState = ApiState.success;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      apiState = ApiState.error;
      notifyListeners();
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser({required String id}) async {
    apiState = ApiState.loading;
    notifyListeners();

    try {
      await UserService.deleteUser(id: id);
      users.removeWhere((u) => u.id == id);
      apiState = ApiState.success;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      apiState = ApiState.error;
      notifyListeners();
      return false;
    }
  }
}
