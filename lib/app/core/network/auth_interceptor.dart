import 'package:dio/dio.dart';

import '../services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._authService, this._dio);

  final AuthService _authService;
  final Dio _dio;

  bool _hasUnauthorizedEnvelope(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return false;
    }

    final status = (data['status'] as num?)?.toInt();
    if (status == 401) {
      return true;
    }

    final message = data['message']?.toString().toLowerCase() ?? '';
    return message.contains('unauthorized') ||
        message.contains('invalid or expired token') ||
        message.contains('no autenticado');
  }

  bool _shouldTryRefresh(RequestOptions request, {required bool unauthorized}) {
    final wasRetried = request.extra['retried'] == true;
    final skipRefresh = request.extra['skipRefresh'] == true;
    return unauthorized && !wasRetried && !skipRefresh;
  }

  Future<Response<dynamic>?> _retryWithRefresh(RequestOptions request) async {
    final refreshed = await _authService.refreshToken();
    if (!refreshed) {
      await _authService.handleTokenExpired();
      return null;
    }

    final newToken = _authService.token;
    if (newToken == null || newToken.isEmpty) {
      await _authService.handleTokenExpired();
      return null;
    }

    final retryRequest = request.copyWith(
      headers: {
        ...request.headers,
        'Authorization': 'Bearer $newToken',
      },
      extra: {
        ...request.extra,
        'retried': true,
      },
    );

    return _dio.fetch<dynamic>(retryRequest);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.extra['skipAuth'] == true) {
      handler.next(options);
      return;
    }

    final token = _authService.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final unauthorized = _hasUnauthorizedEnvelope(response.data);
    final request = response.requestOptions;

    if (!_shouldTryRefresh(request, unauthorized: unauthorized)) {
      handler.next(response);
      return;
    }

    try {
      final retried = await _retryWithRefresh(request);
      if (retried != null) {
        handler.resolve(retried);
        return;
      }
      handler.next(response);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized =
        err.response?.statusCode == 401 || _hasUnauthorizedEnvelope(err.response?.data);

    if (!_shouldTryRefresh(request, unauthorized: isUnauthorized)) {
      handler.next(err);
      return;
    }

    try {
      final retried = await _retryWithRefresh(request);
      if (retried != null) {
        handler.resolve(retried);
        return;
      }
      handler.next(err);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
