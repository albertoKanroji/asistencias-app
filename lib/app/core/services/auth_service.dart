import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/api_envelope.dart';
import '../network/api_endpoints.dart';
import '../../modules/auth/models/auth_login_result.dart';
import '../../modules/auth/models/auth_user.dart';
import '../../routes/app_routes.dart';

class AuthService extends GetxService {
  static const _tokenCacheKey = 'auth_token';
  static const _profileCacheKey = 'auth_profile';

  AuthService()
      : _authDio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );

  final RxnString _token = RxnString();
  final Rxn<AuthUser> _currentUser = Rxn<AuthUser>();
  final Dio _authDio;
  Completer<bool>? _refreshCompleter;
  late final Future<void> _sessionRestoreFuture = _restoreSessionFromCache();

  String? get token => _token.value;
  AuthUser? get currentUser => _currentUser.value;
  Rxn<AuthUser> get currentUserRx => _currentUser;

  bool get isLoggedIn => token != null;

  Future<void> ensureSessionLoaded() => _sessionRestoreFuture;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _authDio.post<Map<String, dynamic>>(
        ApiEndpoints.auth.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      final envelope = ApiEnvelope<AuthLoginResult>.fromJson(
        response.data ?? const {},
        (value) => AuthLoginResult.fromJson(value as Map<String, dynamic>),
      );

      if (envelope.data.isEmpty || envelope.data.first.token.isEmpty) {
        return false;
      }

      _token.value = envelope.data.first.token;
      _currentUser.value = envelope.data.first.user;
      await _saveSessionToCache();
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final envelope = ApiEnvelope<dynamic>.fromJson(data, (value) => value);
        if (envelope.message.isNotEmpty) {
          Get.snackbar('Error', envelope.message);
        }
      }
      return false;
    }
  }

  Future<bool> refreshToken() async {
    final currentToken = _token.value;
    if (currentToken == null || currentToken.isEmpty) {
      return false;
    }

    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final response = await _authDio.post<Map<String, dynamic>>(
        ApiEndpoints.auth.refresh,
        options: Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      final envelope = ApiEnvelope<Map<String, dynamic>>.fromJson(
        response.data ?? const {},
        (value) => value as Map<String, dynamic>,
      );

      if (envelope.data.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final newToken = envelope.data.first['token']?.toString() ?? '';
      if (newToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      _token.value = newToken;
      await _saveSessionToCache();
      _refreshCompleter!.complete(true);
      return true;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<AuthUser?> fetchProfile() async {
    final currentToken = _token.value;
    if (currentToken == null || currentToken.isEmpty) {
      return null;
    }

    final response = await _authDio.get<Map<String, dynamic>>(
      ApiEndpoints.auth.profile,
      options: Options(
        headers: {'Authorization': 'Bearer $currentToken'},
      ),
    );

    final envelope = ApiEnvelope<AuthUser>.fromJson(
      response.data ?? const {},
      (value) => AuthUser.fromJson(value as Map<String, dynamic>),
    );

    if (envelope.data.isEmpty) {
      return null;
    }

    _currentUser.value = envelope.data.first;
    await _saveSessionToCache();
    return _currentUser.value;
  }

  Future<void> logout() async {
    final currentToken = _token.value;
    if (currentToken != null && currentToken.isNotEmpty) {
      try {
        await _authDio.post<Map<String, dynamic>>(
          ApiEndpoints.auth.logout,
          options: Options(
            headers: {'Authorization': 'Bearer $currentToken'},
          ),
        );
      } catch (_) {}
    }

    _token.value = null;
    _currentUser.value = null;
    await _clearSessionCache();
    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> handleTokenExpired() async {
    _token.value = null;
    _currentUser.value = null;
    await _clearSessionCache();
    Get.snackbar('Sesión expirada', 'Tu token venció. Inicia sesión nuevamente.');
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> _restoreSessionFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedToken = prefs.getString(_tokenCacheKey);
    final cachedProfile = prefs.getString(_profileCacheKey);

    if (cachedToken != null && cachedToken.isNotEmpty) {
      _token.value = cachedToken;
    }

    if (cachedProfile != null && cachedProfile.isNotEmpty) {
      try {
        final map = jsonDecode(cachedProfile) as Map<String, dynamic>;
        _currentUser.value = AuthUser.fromJson(map);
      } catch (_) {
        _currentUser.value = null;
      }
    }
  }

  Future<void> _saveSessionToCache() async {
    final prefs = await SharedPreferences.getInstance();

    final currentToken = _token.value;
    if (currentToken != null && currentToken.isNotEmpty) {
      await prefs.setString(_tokenCacheKey, currentToken);
    }

    final user = _currentUser.value;
    if (user != null) {
      await prefs.setString(_profileCacheKey, jsonEncode(user.toJson()));
    }
  }

  Future<void> _clearSessionCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenCacheKey);
    await prefs.remove(_profileCacheKey);
  }
}
