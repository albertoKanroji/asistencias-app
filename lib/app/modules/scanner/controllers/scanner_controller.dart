import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/movement_sync_service.dart';
import '../constants/scanner_constants.dart';
import '../models/scanned_employee.dart';
import '../services/scanner_service.dart';

class ScannerController extends GetxController {
  ScannerController(this._service, this._movementSyncService);

  final ScannerService _service;
  final MovementSyncService _movementSyncService;
  final message = ''.obs;
  final lastCode = ''.obs;
  final isLoadingEmployee = false.obs;
  final isSaving = false.obs;
  final scannedEmployees = <ScannedEmployee>[].obs;
  final selectedDriverId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    message.value = await _service.getData();
  }

  void setLastCode(String code) {
    lastCode.value = code;
  }

  String _normalizeCurp(String value) => value.trim().toUpperCase();

  Future<void> processScannedCurp(String curp) async {
    final sanitizedCurp = _normalizeCurp(curp);
    if (sanitizedCurp.isEmpty || isLoadingEmployee.value) {
      return;
    }

    setLastCode(sanitizedCurp);
    isLoadingEmployee.value = true;

    try {
      final employee = await _service.getEmployeeByCurp(sanitizedCurp);

      if (employee == null) {
        Get.snackbar(
          ScannerConstants.noResultsTitle,
          ScannerConstants.noEmployeeByCurp,
        );
        return;
      }

      final alreadyAdded = scannedEmployees.any(
        (person) => _normalizeCurp(person.curp) == _normalizeCurp(employee.curp),
      );

      if (alreadyAdded) {
        Get.snackbar(
          ScannerConstants.duplicateTitle,
          ScannerConstants.duplicateEmployee,
        );
        return;
      }

      scannedEmployees.add(employee);
      Get.snackbar(ScannerConstants.personAddedTitle, employee.fullName);
    } catch (e) {
      Get.snackbar(
        ScannerConstants.errorTitle,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoadingEmployee.value = false;
    }
  }

  void removeEmployeeByCurp(String curp) {
    final normalizedCurp = _normalizeCurp(curp);
    ScannedEmployee? removedEmployee;
    for (final person in scannedEmployees) {
      if (_normalizeCurp(person.curp) == normalizedCurp) {
        removedEmployee = person;
        break;
      }
    }

    scannedEmployees.removeWhere(
      (person) => _normalizeCurp(person.curp) == normalizedCurp,
    );

    if (removedEmployee != null && selectedDriverId.value == removedEmployee.id) {
      selectedDriverId.value = null;
    }
  }

  void selectDriver(int employeeId) {
    selectedDriverId.value = employeeId;
  }

  bool get canConfirmDeparture => scannedEmployees.isNotEmpty;

    bool get allScannedAreReturn =>
      scannedEmployees.isNotEmpty &&
      scannedEmployees.every((employee) => employee.hasPendingTc15Exit);

    String get confirmActionLabel => allScannedAreReturn
      ? ScannerConstants.confirmEntryButton
      : ScannerConstants.confirmDepartureButton;

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Map<String, dynamic> _buildDeparturePayload({required String message}) {
    final now = DateTime.now();
    final time =
        '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
    final date =
        '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';

    return {
      'time': time,
      'date': date,
      'message': message,
      'employees': scannedEmployees.map((employee) => employee.id).toList(),
    };
  }

  Future<bool> saveAttendance({String notes = ''}) async {
    if (!canConfirmDeparture || isSaving.value) {
      return false;
    }

    final normalizedNotes = notes.trim();
    if (!allScannedAreReturn && normalizedNotes.isEmpty) {
      Get.snackbar(
        ScannerConstants.requiredFieldTitle,
        ScannerConstants.requiredExitReason,
      );
      return false;
    }

    isSaving.value = true;
    try {
      final message = allScannedAreReturn ? '' : normalizedNotes;
      final payload = _buildDeparturePayload(message: message);
      debugPrint('Departure payload: $payload');
      await _service.registerMovement(payload: payload);
      _clearScannedUsers();
      _movementSyncService.notifyRegisteredMovement();
      Get.snackbar(ScannerConstants.savedTitle, ScannerConstants.savedMessage);
      return true;
    } catch (e) {
      Get.snackbar(
        ScannerConstants.errorTitle,
        e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void _clearScannedUsers() {
    scannedEmployees.clear();
    selectedDriverId.value = null;
    lastCode.value = '';
  }
}
