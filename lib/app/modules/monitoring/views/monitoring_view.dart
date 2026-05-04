import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/monitoring_controller.dart';
import 'components/monitoring_filters_sheet.dart';
import 'components/monitoring_list.dart';
import 'components/monitoring_tabs_header.dart';

class MonitoringView extends StatefulWidget {
  const MonitoringView({super.key});

  @override
  State<MonitoringView> createState() => _MonitoringViewState();
}

class _MonitoringViewState extends State<MonitoringView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final MonitoringController controller = Get.find<MonitoringController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => MonitoringTabsHeader(
            tabController: _tabController,
            hasFilters: controller.filters.value.hasAny,
            onShowFilters: () => _showFiltersSheet(context),
            onClearFilters: controller.clearFilters,
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              controller: _tabController,
              children: [
                MonitoringList(
                  items: controller.pending,
                  isLoadingMore: controller.isLoadingMorePending.value,
                  onEndReached: controller.loadMorePending,
                  onReload: controller.load,
                  reloadButtonKey: 'pending',
                ),
                MonitoringList(
                  items: controller.exits,
                  isLoadingMore: controller.isLoadingMoreExits.value,
                  onEndReached: controller.loadMoreExits,
                  onReload: controller.load,
                  reloadButtonKey: 'exits',
                ),
                MonitoringList(
                  items: controller.entries,
                  isLoadingMore: controller.isLoadingMoreEntries.value,
                  onEndReached: controller.loadMoreEntries,
                  onReload: controller.load,
                  reloadButtonKey: 'entries',
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Future<void> _showFiltersSheet(BuildContext context) async {
    final selected = await showMonitoringFiltersSheet(
      context,
      controller.filters.value,
    );

    if (selected != null) {
      await controller.applyFilters(selected);
    }
  }
}
