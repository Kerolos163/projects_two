import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/api/api_service.dart';

class CategoryService {
  final ApiService _api = ApiService();
  static const String baseUrl = '${ApiEndPoints.baseUrl}api/categories';

  Future<List<dynamic>> getCategories() async {
    final response = await _api.get(baseUrl);
    return response.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> getCategory(String id) async {
    final response = await _api.get('$baseUrl/$id');
    return response.data['data'];
  }

  Future<Response> addCategory({
    required String name,
    required File image,
  }) async {
    final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';

    final body = {
      'name': name,
      'image': await MultipartFile.fromFile(
        image.path,
        contentType: MediaType.parse(mimeType),
        filename: basename(image.path),
      ),
    };

    return await _api.post(baseUrl, body: body, isFormData: true);
  }

  Future<Response> updateCategory({
    required String id,
    required String name,
    File? image,
  }) async {
    final Map<String, dynamic> body = {'name': name};

    if (image != null) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      body['image'] = await MultipartFile.fromFile(
        image.path,
        contentType: MediaType.parse(mimeType),
        filename: basename(image.path),
      );
    }

    return await _api.put('$baseUrl/$id', body: body, isFormData: true);
  }

  Future<void> deleteCategory(String id) async {
    final response = await _api.delete('$baseUrl/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }
}
