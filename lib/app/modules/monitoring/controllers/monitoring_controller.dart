import 'package:get/get.dart';

import '../../../core/services/movement_sync_service.dart';
import '../constants/monitoring_constants.dart';
import '../models/monitoring_filters.dart';
import '../models/monitoring_record.dart';
import '../services/monitoring_service.dart';

class MonitoringController extends GetxController {
  MonitoringController(this._service, this._movementSyncService);

  final MonitoringService _service;
  final MovementSyncService _movementSyncService;
  static const int _pageSize = MonitoringConstants.pageSize;

  final entries = <MonitoringRecord>[].obs;
  final exits = <MonitoringRecord>[].obs;
  final pending = <MonitoringRecord>[].obs;
  final isLoading = false.obs;
  final isLoadingMoreEntries = false.obs;
  final isLoadingMoreExits = false.obs;
  final isLoadingMorePending = false.obs;
  final hasMoreEntries = true.obs;
  final hasMoreExits = true.obs;
  final hasMorePending = true.obs;
  final filters = const MonitoringFilters().obs;

  int _entriesPage = 1;
  int _exitsPage = 1;
  int _pendingPage = 1;
  Worker? _movementWorker;

  @override
  void onInit() {
    super.onInit();
    _movementWorker = ever<int>(_movementSyncService.refreshSignal, (_) {
      load();
    });
    load();
  }

  @override
  void onClose() {
    _movementWorker?.dispose();
    super.onClose();
  }

  Future<void> load() async {
    isLoading.value = true;
    _entriesPage = 1;
    _exitsPage = 1;
    _pendingPage = 1;

    try {
      final responses = await Future.wait([
        _service.getEntries(
          page: _entriesPage,
          pageSize: _pageSize,
          filters: filters.value,
        ),
        _service.getExits(
          page: _exitsPage,
          pageSize: _pageSize,
          filters: filters.value,
        ),
        _service.getPendings(
          page: _pendingPage,
          pageSize: _pageSize,
          filters: filters.value,
        ),
      ]);

      final entriesResponse = responses[0];
      final exitsResponse = responses[1];
      final pendingResponse = responses[2];

      entries.assignAll(entriesResponse.items);
      exits.assignAll(exitsResponse.items);
      pending.assignAll(pendingResponse.items);
      hasMoreEntries.value = entriesResponse.hasNext;
      hasMoreExits.value = exitsResponse.hasNext;
      hasMorePending.value = pendingResponse.hasNext;
    } catch (e) {
      Get.snackbar(
        MonitoringConstants.errorTitle,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreEntries() async {
    if (!hasMoreEntries.value || isLoadingMoreEntries.value || isLoading.value) {
      return;
    }

    isLoadingMoreEntries.value = true;
    try {
      final nextPage = _entriesPage + 1;
      final response = await _service.getEntries(
        page: nextPage,
        pageSize: _pageSize,
        filters: filters.value,
      );
      _entriesPage = nextPage;
      entries.addAll(response.items);
      hasMoreEntries.value = response.hasNext;
    } catch (e) {
      Get.snackbar(
        MonitoringConstants.errorTitle,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoadingMoreEntries.value = false;
    }
  }

  Future<void> loadMoreExits() async {
    if (!hasMoreExits.value || isLoadingMoreExits.value || isLoading.value) {
      return;
    }

    isLoadingMoreExits.value = true;
    try {
      final nextPage = _exitsPage + 1;
      final response = await _service.getExits(
        page: nextPage,
        pageSize: _pageSize,
        filters: filters.value,
      );
      _exitsPage = nextPage;
      exits.addAll(response.items);
      hasMoreExits.value = response.hasNext;
    } catch (e) {
      Get.snackbar(
        MonitoringConstants.errorTitle,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoadingMoreExits.value = false;
    }
  }

  Future<void> loadMorePending() async {
    if (!hasMorePending.value || isLoadingMorePending.value || isLoading.value) {
      return;
    }

    isLoadingMorePending.value = true;
    try {
      final nextPage = _pendingPage + 1;
      final response = await _service.getPendings(
        page: nextPage,
        pageSize: _pageSize,
        filters: filters.value,
      );
      _pendingPage = nextPage;
      pending.addAll(response.items);
      hasMorePending.value = response.hasNext;
    } catch (e) {
      Get.snackbar(
        MonitoringConstants.errorTitle,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoadingMorePending.value = false;
    }
  }

  Future<void> applyFilters(MonitoringFilters newFilters) async {
    filters.value = newFilters;
    await load();
  }

  Future<void> clearFilters() async {
    filters.value = const MonitoringFilters();
    await load();
  }
}
