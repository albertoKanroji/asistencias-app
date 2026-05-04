import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';

class HomeController extends GetxController {
  HomeController(this.authService);

  final AuthService authService;
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
