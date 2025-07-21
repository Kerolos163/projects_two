import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/api/api_service.dart';
import '../../../../Core/models/user_model.dart';

class UserService {
  static final ApiService _apiService = ApiService();
  static const String _baseUrl = "${ApiEndPoints.baseUrl}api/users";

  /// Get all users
  static Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiService.get(_baseUrl);
      final List data = response.data['data']['users'];
      return data.map((e) => UserModel.fromJson2(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  /// Get user by ID
  static Future<UserModel> getUserById(String id) async {
    try {
      final response = await _apiService.get("$_baseUrl/$id");
      final userJson = response.data['data'];
      return UserModel.fromJson(userJson);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  /// Update user info
  static Future<UserModel> updateUser({
    required String id,
    required UserModel user,
  }) async {
    try {
      final response = await _apiService.patch(
        "$_baseUrl/$id",
        body: user.toJsonForUpdate(),
      );
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user
  static Future<void> deleteUser({required String id}) async {
    try {
      await _apiService.delete("$_baseUrl/$id");
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
