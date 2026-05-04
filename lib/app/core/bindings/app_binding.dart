import 'package:get/get.dart';

import '../network/api_client.dart';
import '../services/auth_service.dart';
import '../services/kiosk_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ApiClient>(ApiClient(Get.find<AuthService>()), permanent: true);
    Get.put<KioskService>(KioskService(), permanent: true);
  }
}
