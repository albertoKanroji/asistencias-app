import 'package:flutter/material.dart';

import '../../constants/monitoring_constants.dart';

class MonitoringTabsHeader extends StatelessWidget {
  const MonitoringTabsHeader({
    required this.tabController,
    required this.hasFilters,
    required this.onShowFilters,
    required this.onClearFilters,
    super.key,
  });

  final TabController tabController;
  final bool hasFilters;
  final VoidCallback onShowFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: tabController,
              labelStyle: TextStyle(
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: MonitoringConstants.tabPending),
                Tab(text: MonitoringConstants.tabExits),
                Tab(text: MonitoringConstants.tabEntries),
              ],
            ),
          ),
          IconButton(
            onPressed: onShowFilters,
            tooltip: MonitoringConstants.filtersTooltip,
            icon: const Icon(Icons.filter_list),
          ),
          if (hasFilters)
            TextButton(
              onPressed: onClearFilters,
              child: const Text(MonitoringConstants.clearFiltersButton),
            ),
        ],
      ),
    );
  }
}
