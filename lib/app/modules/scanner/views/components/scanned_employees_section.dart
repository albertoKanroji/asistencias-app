import 'package:flutter/material.dart';

import '../../constants/scanner_constants.dart';
import '../../models/scanned_employee.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import 'employee_card.dart';

class ScannedEmployeesSection extends StatelessWidget {
  const ScannedEmployeesSection({
    required this.employees,
    required this.selectedDriverId,
    required this.onSelectDriver,
    required this.onRemove,
    required this.onConfirmDeparture,
    required this.canConfirmDeparture,
    required this.isSaving,
    required this.confirmActionLabel,
    required this.hideDriverSelection,
    super.key,
  });

  final List<ScannedEmployee> employees;
  final int? selectedDriverId;
  final ValueChanged<int> onSelectDriver;
  final ValueChanged<String> onRemove;
  final VoidCallback? onConfirmDeparture;
  final bool canConfirmDeparture;
  final bool isSaving;
  final String confirmActionLabel;
  final bool hideDriverSelection;

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${ScannerConstants.scannedPeoplePrefix} (${employees.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (!hideDriverSelection) ...[
          Text(
            ScannerConstants.selectDriverHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
        ],
        ...employees.map(
          (person) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: EmployeeCard(
              fullName: person.fullName,
              imageUrl: person.image,
              actions: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MovementBadge(isReturn: person.hasPendingTc15Exit),
                      if (!hideDriverSelection) ...[
                        const SizedBox(width: 6),
                        Text(
                          ScannerConstants.driverLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Checkbox(
                          value: selectedDriverId == person.id,
                          onChanged: (_) => onSelectDriver(person.id),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ],
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                    onPressed: () => onRemove(person.curp),
                    icon: const Icon(Icons.delete_outline),
                    tooltip: ScannerConstants.deleteTooltip,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AppPrimaryButton(
          label: confirmActionLabel,
          isLoading: isSaving,
          onPressed: canConfirmDeparture ? onConfirmDeparture : null,
        ),
      ],
    );
  }
}

class _MovementBadge extends StatelessWidget {
  const _MovementBadge({required this.isReturn});

  final bool isReturn;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isReturn ? Colors.red.shade600 : Colors.green.shade600;
    final label = isReturn
        ? ScannerConstants.badgeReturn
        : ScannerConstants.badgeExit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
