import 'package:get/get.dart';

class MovementSyncService extends GetxService {
  final refreshSignal = 0.obs;

  void notifyRegisteredMovement() {
    refreshSignal.value = refreshSignal.value + 1;
  }
}
