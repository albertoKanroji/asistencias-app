import 'package:get/get.dart';

import '../constants/settings_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/kiosk_service.dart';
import '../services/settings_service.dart';

class SettingsController extends GetxController {
  SettingsController(this._service, this._authService, this._kioskService);

  final SettingsService _service;
  final AuthService _authService;
  final KioskService _kioskService;
  final message = ''.obs;
  final isUnlockingKiosk = false.obs;

  String get fullName => _authService.currentUser?.name ?? SettingsConstants.emptyValue;
  String get username => _authService.currentUser?.username ?? SettingsConstants.emptyValue;
  String get email => _authService.currentUser?.email ?? SettingsConstants.emptyValue;
  String get area => _authService.currentUser?.area ?? SettingsConstants.emptyValue;
  String get position => _authService.currentUser?.position ?? SettingsConstants.emptyValue;
  String? get photo => _authService.currentUser?.photo;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    message.value = await _service.getData();
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> unlockKioskWithPin(String pin) async {
    if (isUnlockingKiosk.value) {
      return;
    }

    if (pin.trim() != SettingsConstants.kioskExitPin) {
      Get.snackbar(SettingsConstants.kioskSectionTitle, SettingsConstants.kioskPinInvalid);
      return;
    }

    isUnlockingKiosk.value = true;
    try {
      final disabled = await _kioskService.disableKiosk();
      if (disabled) {
        Get.snackbar(
          SettingsConstants.kioskSectionTitle,
          SettingsConstants.kioskExitSuccess,
        );
      } else {
        Get.snackbar(
          SettingsConstants.kioskSectionTitle,
          SettingsConstants.kioskExitFailed,
        );
      }
    } finally {
      isUnlockingKiosk.value = false;
    }
  }

  Future<void> ensureKioskEnabled() async {
    await _kioskService.enableKiosk();
  }

  Future<bool> isKioskFullyPermitted() async {
    return _kioskService.isLockTaskPermitted();
  }
}
