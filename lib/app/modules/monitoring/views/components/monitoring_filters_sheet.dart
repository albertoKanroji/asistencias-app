import 'package:flutter/material.dart';

import '../../constants/monitoring_constants.dart';
import '../../models/monitoring_filters.dart';

Future<MonitoringFilters?> showMonitoringFiltersSheet(
  BuildContext context,
  MonitoringFilters current,
) async {
  final searchController = TextEditingController(text: current.search ?? '');
  final userIdController = TextEditingController(
    text: current.userId?.toString() ?? '',
  );

  DateTime? startDate = current.startDate;
  DateTime? endDate = current.endDate;
  String sortBy = current.sortBy ?? '';
  String sortOrder = current.sortOrder ?? '';

  final selected = await showModalBottomSheet<MonitoringFilters>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (_, setSheetState) {
        Future<void> pickDate({required bool isStart}) async {
          final picked = await showDatePicker(
            context: sheetContext,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
          );
          if (picked == null) {
            return;
          }
          setSheetState(() {
            if (isStart) {
              startDate = picked;
            } else {
              endDate = picked;
            }
          });
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  MonitoringConstants.filtersTitle,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: MonitoringConstants.searchLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: userIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: MonitoringConstants.userIdLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickDate(isStart: true),
                        child: Text(
                          startDate == null
                              ? MonitoringConstants.startDateLabel
                              : 'Inicio: ${startDate!.toIso8601String().split('T').first}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickDate(isStart: false),
                        child: Text(
                          endDate == null
                              ? MonitoringConstants.endDateLabel
                              : 'Fin: ${endDate!.toIso8601String().split('T').first}',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: sortBy.isEmpty ? null : sortBy,
                  decoration: const InputDecoration(
                    labelText: MonitoringConstants.sortByLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: MonitoringConstants.sortDate,
                      child: Text(MonitoringConstants.sortDate),
                    ),
                    DropdownMenuItem(
                      value: MonitoringConstants.sortTime,
                      child: Text(MonitoringConstants.sortTime),
                    ),
                    DropdownMenuItem(
                      value: MonitoringConstants.sortFullName,
                      child: Text(MonitoringConstants.sortFullName),
                    ),
                  ],
                  onChanged: (value) => setSheetState(() => sortBy = value ?? ''),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: sortOrder.isEmpty ? null : sortOrder,
                  decoration: const InputDecoration(
                    labelText: MonitoringConstants.sortOrderLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: MonitoringConstants.sortAsc,
                      child: Text(MonitoringConstants.sortAsc),
                    ),
                    DropdownMenuItem(
                      value: MonitoringConstants.sortDesc,
                      child: Text(MonitoringConstants.sortDesc),
                    ),
                  ],
                  onChanged: (value) => setSheetState(() => sortOrder = value ?? ''),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop(
                      MonitoringFilters(
                        search: searchController.text.trim().isEmpty
                            ? null
                            : searchController.text.trim(),
                        userId: int.tryParse(userIdController.text.trim()),
                        startDate: startDate,
                        endDate: endDate,
                        sortBy: sortBy.isEmpty ? null : sortBy,
                        sortOrder: sortOrder.isEmpty ? null : sortOrder,
                      ),
                    );
                  },
                  child: const Text(MonitoringConstants.applyFiltersButton),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  searchController.dispose();
  userIdController.dispose();

  return selected;
}
