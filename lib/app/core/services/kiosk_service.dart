import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class KioskService extends GetxService {
  static const MethodChannel _channel =
      MethodChannel('registro_asistencia/kiosk');

  @override
  void onInit() {
    super.onInit();
    enableKiosk();
  }

  Future<bool> enableKiosk() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('startKiosk');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> disableKiosk() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('stopKiosk');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isInKioskMode() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('isInKiosk');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isLockTaskPermitted() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('isLockTaskPermitted');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }
}
