import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../services/auth_service.dart';
import 'auth_interceptor.dart';

class ApiClient {
  ApiClient(AuthService authService)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ) {
    dio.interceptors.add(AuthInterceptor(authService, dio));
  }

  final Dio dio;
}
