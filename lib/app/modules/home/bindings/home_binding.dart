import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/kiosk_service.dart';
import '../../../core/services/movement_sync_service.dart';
import '../../contractors/controllers/contractors_controller.dart';
import '../../contractors/services/contractors_service.dart';
import '../../monitoring/controllers/monitoring_controller.dart';
import '../../monitoring/services/monitoring_service.dart';
import '../../scanner/controllers/scanner_controller.dart';
import '../../scanner/services/scanner_service.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../settings/services/settings_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(Get.find<AuthService>()));
    Get.lazyPut<MovementSyncService>(MovementSyncService.new);

    Get.lazyPut<ScannerService>(() => ScannerService(Get.find<ApiClient>()));
    Get.lazyPut<ScannerController>(
      () => ScannerController(
        Get.find<ScannerService>(),
        Get.find<MovementSyncService>(),
      ),
    );

    Get.lazyPut<MonitoringService>(
      () => MonitoringService(Get.find<ApiClient>()),
    );
    Get.lazyPut<MonitoringController>(
      () => MonitoringController(
        Get.find<MonitoringService>(),
        Get.find<MovementSyncService>(),
      ),
    );

    Get.lazyPut<ContractorsService>(ContractorsService.new);
    Get.lazyPut<ContractorsController>(
      () => ContractorsController(Get.find<ContractorsService>()),
    );

    Get.lazyPut<SettingsService>(SettingsService.new);
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<SettingsService>(),
        Get.find<AuthService>(),
        Get.find<KioskService>(),
      ),
    );
  }
}
