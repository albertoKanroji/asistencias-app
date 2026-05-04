import 'monitoring_record.dart';

class MonitoringPagedResult {
  const MonitoringPagedResult({
    required this.items,
    required this.totalPages,
    required this.hasNext,
    required this.page,
  });

  final List<MonitoringRecord> items;
  final int totalPages;
  final bool hasNext;
  final int page;
}
