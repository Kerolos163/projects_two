import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/api/api_service.dart';

class SubCategoryService {
  final ApiService _api = ApiService();
  static const String baseUrl = '${ApiEndPoints.baseUrl}api/categories';

  Future<Response> createSubCategory({
    required String categoryId,
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

    return await _api.post(
      '$baseUrl/$categoryId/subcategories',
      body: body,
      isFormData: true,
    );
  }

  Future<List<dynamic>> getSubCategories(String categoryId) async {
    final response = await _api.get('$baseUrl/$categoryId/subcategories');
    return response.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> getSubCategory(String id) async {
    final response = await _api.get(
      '${ApiEndPoints.baseUrl}api/subcategories/$id',
    );
    return response.data['data'];
  }

  Future<Response> updateSubCategory({
    required String id,
    required String name,
    required String category,
    File? image,
  }) async {
    final Map<String, dynamic> body = {'name': name, 'category': category};

    if (image != null) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      body['image'] = await MultipartFile.fromFile(
        image.path,
        contentType: MediaType.parse(mimeType),
        filename: basename(image.path),
      );
    }

    return await _api.put(
      '${ApiEndPoints.baseUrl}api/subcategories/$id',
      body: body,
      isFormData: true,
    );
  }

  Future<void> deleteSubCategory(String id) async {
    final response = await _api.delete(
      '${ApiEndPoints.baseUrl}api/subcategories/$id',
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete subcategory');
    }
  }
}
