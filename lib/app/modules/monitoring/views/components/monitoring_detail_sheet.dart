import 'package:flutter/material.dart';

import '../../constants/monitoring_constants.dart';
import '../../models/monitoring_record.dart';

class MonitoringDetailSheet extends StatelessWidget {
  const MonitoringDetailSheet({required this.record, super.key});

  final MonitoringRecord record;

  @override
  Widget build(BuildContext context) {
    Widget item(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                MonitoringConstants.detailTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              item(MonitoringConstants.detailId, record.id.toString()),
              item(MonitoringConstants.detailUserId, record.userId.toString()),
              item(MonitoringConstants.detailName, record.fullName),
              item(MonitoringConstants.detailType, record.type),
              item(MonitoringConstants.detailDate, record.date),
              item(MonitoringConstants.detailTime, record.time),
              item(
                MonitoringConstants.detailStatus,
                record.status ?? MonitoringConstants.emptyValue,
              ),
              item(
                MonitoringConstants.detailReason,
                record.reason ?? MonitoringConstants.emptyValue,
              ),
              item(
                MonitoringConstants.detailDevice,
                record.device ?? MonitoringConstants.emptyValue,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(MonitoringConstants.closeButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
