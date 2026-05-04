import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../controllers/login_controller.dart';
import '../services/login_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginService>(() => LoginService(Get.find<AuthService>()));
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginService>(), Get.find<AuthService>()),
    );
  }
}
