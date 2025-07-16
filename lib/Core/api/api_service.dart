import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../Services/preferences_manager.dart';
import '../constant/app_strings.dart';
import '../errors/exceptions.dart';
import '../utils/app_constants.dart';
import 'api_end_points.dart';
import 'dio_interceptors.dart';
import 'status_code.dart';

class ApiService {
  static final ApiService _singleton = ApiService._internal();
  final Dio _dio = Dio();

  factory ApiService() {
    return _singleton;
  }

  ApiService._internal() {
    _dio.options.baseUrl = ApiEndPoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    final token = PreferencesManager.getString(AppConstants.userTokenKey);

    _dio.options.headers = {
      // "Content-Type": "multipart/form-data",
      // "Content-Type": "application/json",
      "Accept": "application/json, text/plain, */*",
      'Authorization': 'Bearer $token',
    };
    _dio.interceptors.add(DioInterceptor());
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponseJson(response);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    bool isFormData = false,
  }) async {
    try {
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(body!) : body,
      );
      return _handleResponseJson(response);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> patch(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    bool isFormData = false,
  }) async {
    log("🫵");
    log(body.toString());
    try {
      final response = await _dio.patch(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(body!) : body,
      );
      return _handleResponseJson(response);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    bool isFormData = false,
  }) async {
    try {
      final response = await _dio.put(
        path,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(body!) : body,
      );
      return _handleResponseJson(response);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        data: body,
      );

      return _handleResponseJson(response);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  bool isValidResponse(int statusCode) {
    return statusCode >= 200 && statusCode <= 302;
  }

  dynamic _handleResponseJson(Response response) {
    return response;
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw FetchDataException(AppStrings.connectionTimeoutError.tr());
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw BadRequestException(error.response?.data);
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw UnauthorizedException(error.response?.data["message"]);
          case StatusCode.notFound:
            throw NotFoundException(error.response?.data["message"]);
          case StatusCode.conflict:
            throw ConflictException(error.response?.data);
          case StatusCode.unProcessableEntity:
            throw UnProcessableEntityException(error.response?.data);
          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
          default:
            throw FetchDataException(AppStrings.connectionTimeoutError.tr());
        }
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw NoInternetException(AppStrings.noInternetConnection.tr());
      case DioExceptionType.badCertificate:
        throw NoInternetException(AppStrings.noInternetConnection.tr());
      case DioExceptionType.connectionError:
        throw NoInternetException(AppStrings.noInternetConnection.tr());
    }
  }
}
