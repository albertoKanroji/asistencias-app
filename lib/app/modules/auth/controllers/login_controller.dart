import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/auth_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../models/login_request.dart';
import '../services/login_service.dart';

class LoginController extends GetxController {
  LoginController(this._loginService, this._authService);

  final LoginService _loginService;
  final AuthService _authService;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    final success = await _loginService.signIn(
      LoginRequest(
        username: usernameController.text.trim(),
        password: passwordController.text,
      ),
    );
    isLoading.value = false;

    if (success) {
      await _authService.fetchProfile();
      Get.offAllNamed(AppRoutes.home);
      return;
    }

    Get.snackbar(
      AuthConstants.loginErrorTitle,
      AuthConstants.invalidCredentials,
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
