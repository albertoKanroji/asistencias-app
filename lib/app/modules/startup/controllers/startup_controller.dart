import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class StartupController extends GetxController {
  StartupController(this._authService);

  final AuthService _authService;

  @override
  void onReady() {
    super.onReady();
    _resolveInitialRoute();
  }

  Future<void> _resolveInitialRoute() async {
    await _authService.ensureSessionLoaded();
    if (_authService.isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
      return;
    }
    Get.offAllNamed(AppRoutes.login);
  }
}
