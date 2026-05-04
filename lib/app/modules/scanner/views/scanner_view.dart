import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/scanner_constants.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../controllers/scanner_controller.dart';
import 'components/exit_reason_sheet.dart';
import 'components/qr_scanner_sheet.dart';
import 'components/scanned_employees_section.dart';

class ScannerView extends GetView<ScannerController> {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ScannerStatusCard(
              //   message: controller.message.value,
              //   lastCode: controller.lastCode.value,
              //   isLoading: controller.isLoadingEmployee.value,
              // ),
              const SizedBox(height: 16),
              AppPrimaryButton(
                label: ScannerConstants.openScannerButton,
                onPressed: () => _openScannerModal(context),
              ),
              const SizedBox(height: 16),
              ScannedEmployeesSection(
                employees: controller.scannedEmployees,
                selectedDriverId: controller.selectedDriverId.value,
                onSelectDriver: controller.selectDriver,
                onRemove: (curp) => _confirmRemoveEmployee(context, curp),
                onConfirmDeparture: () => _confirmSave(context),
                canConfirmDeparture: controller.canConfirmDeparture,
                isSaving: controller.isSaving.value,
                confirmActionLabel: controller.confirmActionLabel,
                hideDriverSelection: controller.allScannedAreReturn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openScannerModal(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => QrScannerSheet(
        onCodeDetected: (code) async {
          await controller.processScannedCurp(code);
        },
      ),
    );
  }

  Future<void> _confirmSave(BuildContext context) async {
    if (!controller.canConfirmDeparture) {
      return;
    }

    if (controller.allScannedAreReturn) {
      await controller.saveAttendance();
      return;
    }

    final notes = await _askExitReason(context);
    if (notes == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    await controller.saveAttendance(notes: notes);
  }

  Future<String?> _askExitReason(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExitReasonSheet(),
    );
  }

  Future<void> _confirmRemoveEmployee(BuildContext context, String curp) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(ScannerConstants.removeCompanionTitle),
        content: const Text(ScannerConstants.removeCompanionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(ScannerConstants.noLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(ScannerConstants.yesLabel),
          ),
        ],
      ),
    );

    if (shouldRemove == true) {
      controller.removeEmployeeByCurp(curp);
    }
  }
}
