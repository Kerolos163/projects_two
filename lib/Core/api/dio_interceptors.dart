import 'package:dio/dio.dart';

import '../Services/preferences_manager.dart';
import '../utils/app_constants.dart';

class DioInterceptor extends Interceptor {
  // Private constructor
  DioInterceptor._internal();
  // Singleton instance
  static final DioInterceptor _singleton = DioInterceptor._internal();

  factory DioInterceptor() {
    return _singleton;
  }

  String? _getCachedToken() {
    return PreferencesManager.getString(AppConstants.userTokenKey);
  }

  String? _getCachedLocale() {
    return PreferencesManager.getString(AppConstants.languagesKey);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cachedToken = _getCachedToken();
    final cachedLocale = _getCachedLocale();
    // AppLogger.instance.log(cachedLocale);
    options
      ..headers[AppConstants.authorization] = (cachedToken != null)
          ? '${AppConstants.bearer} $cachedToken'
          : null
      ..headers[AppConstants.acceptLanguage] =
          cachedLocale?.toUpperCase() ?? AppConstants.enCode.toUpperCase();

    super.onRequest(options, handler);
  }
}
