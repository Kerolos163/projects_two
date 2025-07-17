import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

// import 'package:http_parser/http_parser.dart';
import 'package:projects_two/Core/Services/preferences_manager.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Core/utils/app_constants.dart';
import 'package:path/path.dart';

class ProductService {
  final Dio _dio = Dio(BaseOptions(baseUrl: '${ApiEndPoints.baseUrl}api/'));

  ProductService() {
    _dio.options.headers['Authorization'] =
        'Bearer ${PreferencesManager.getString(AppConstants.userTokenKey)}';

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<List<ProductModel>> getAllProducts() async {
    final response = await _dio.get('products');
    final data = response.data['data'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel?> getProduct(String id) async {
    final response = await _dio.get('products/$id');
    return ProductModel.fromJson(response.data['data']);
  }

  Future<void> deleteProduct(String id) async {
    await _dio.delete('products/$id');
  }

  Future<void> createProduct({
    required String title,
    required String description,
    required int quantity,
    required double price,
    double? priceAfterDiscount,
    required String categoryId,
    List<String>? subCategoryIds,
    List<String>? colors,
    required File imageCover,
    List<File>? images,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'quantity': quantity,
      'price': price,
      if (priceAfterDiscount != null) 'priceAfterDiscount': priceAfterDiscount,
      'category': categoryId,
      if (subCategoryIds != null) 'subCategories': subCategoryIds,
      if (colors != null) 'colors': colors,
      'imageCover': await MultipartFile.fromFile(
        imageCover.path,
        filename: basename(imageCover.path),
        contentType: MediaType.parse(lookupMimeType(imageCover.path) ?? 'image/jpeg'),
      ),
      if (images != null)
        'images': [
          for (final img in images)
            await MultipartFile.fromFile(
              img.path,
              filename: basename(img.path),
              contentType: MediaType.parse(lookupMimeType(img.path) ?? 'image/jpeg'),
            ),
        ],
    });

    await _dio.post('products', data: formData);
  }

  Future<void> updateProduct({
    required String id,
    String? title,
    String? description,
    int? quantity,
    double? price,
    double? priceAfterDiscount,
    String? categoryId,
    List<String>? subCategoryIds,
    List<String>? colors,
    File? imageCover,
    List<File>? images,
  }) async {
    final data = <String, dynamic>{
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (priceAfterDiscount != null) 'priceAfterDiscount': priceAfterDiscount,
      if (categoryId != null) 'category': categoryId,
      if (subCategoryIds != null) 'subCategories': subCategoryIds,
      if (colors != null) 'colors': colors,
    };

    final formData = FormData.fromMap(data);

    if (imageCover != null) {
      final mimeType = lookupMimeType(imageCover.path) ?? 'image/jpeg';
      formData.files.add(
        MapEntry(
          'imageCover',
          await MultipartFile.fromFile(
            imageCover.path,
            filename: basename(imageCover.path),
            contentType: MediaType.parse(mimeType),
          ),
        ),
      );
    }

    if (images != null) {
      for (var img in images) {
        final mimeType = lookupMimeType(img.path) ?? 'image/jpeg';
        print('Image MIME type: $mimeType');
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              img.path,
              filename: basename(img.path),
               contentType: MediaType.parse(mimeType),
            ),
          ),
        );
      }
    }

    await _dio.put('products/$id', data: formData);
  }
}
