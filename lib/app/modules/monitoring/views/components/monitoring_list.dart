import 'package:flutter/material.dart';

import '../../constants/monitoring_constants.dart';
import '../../models/monitoring_record.dart';
import 'monitoring_detail_sheet.dart';
import 'monitoring_type_badge.dart';

class MonitoringList extends StatelessWidget {
  const MonitoringList({
    required this.items,
    required this.isLoadingMore,
    required this.onEndReached,
    required this.onReload,
    required this.reloadButtonKey,
    super.key,
  });

  final List<MonitoringRecord> items;
  final bool isLoadingMore;
  final Future<void> Function() onEndReached;
  final Future<void> Function() onReload;
  final String reloadButtonKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (items.isEmpty)
          const Center(child: Text(MonitoringConstants.noRecords))
        else
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 150) {
                onEndReached();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemBuilder: (_, index) {
                if (index == items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final item = items[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: (item.image != null && item.image!.isNotEmpty)
                        ? NetworkImage(item.image!)
                        : null,
                    child: (item.image == null || item.image!.isEmpty)
                        ? Text(
                            item.fullName.isNotEmpty
                                ? item.fullName.substring(0, 1)
                                : '?',
                          )
                        : null,
                  ),
                  title: Text(
                    item.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(item.date),
                          const SizedBox(width: 8),
                          Text(item.time),
                        ],
                      ),
                      const SizedBox(height: 6),
                      MonitoringTypeBadge(label: item.type),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: MonitoringConstants.detailsTooltip,
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => MonitoringDetailSheet(record: item),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 18),
              itemCount: items.length + (isLoadingMore ? 1 : 0),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.small(
            heroTag: 'monitoring_reload_$reloadButtonKey',
            tooltip: MonitoringConstants.reloadTooltip,
            onPressed: onReload,
            child: const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
