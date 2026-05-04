import 'package:dio/dio.dart';

import '../../../core/models/api_envelope.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../constants/monitoring_constants.dart';
import '../models/monitoring_filters.dart';
import '../models/monitoring_paged_result.dart';
import '../models/monitoring_record.dart';

class MonitoringService {
  MonitoringService(this._apiClient);

  final ApiClient _apiClient;

  Future<MonitoringPagedResult> getEntries({
    required int page,
    required int pageSize,
    required MonitoringFilters filters,
  }) async {
    return _fetch(
      path: ApiEndpoints.extraordinary.entries,
      page: page,
      pageSize: pageSize,
      filters: filters,
    );
  }

  Future<MonitoringPagedResult> getExits({
    required int page,
    required int pageSize,
    required MonitoringFilters filters,
  }) async {
    return _fetch(
      path: ApiEndpoints.extraordinary.exits,
      page: page,
      pageSize: pageSize,
      filters: filters,
    );
  }

  Future<MonitoringPagedResult> getPendings({
    required int page,
    required int pageSize,
    required MonitoringFilters filters,
  }) async {
    return _fetch(
      path: ApiEndpoints.extraordinary.pending,
      page: page,
      pageSize: pageSize,
      filters: filters,
    );
  }

  Future<MonitoringPagedResult> _fetch({
    required String path,
    required int page,
    required int pageSize,
    required MonitoringFilters filters,
  }) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        path,
        queryParameters: filters.toQuery(page: page, pageSize: pageSize),
      );

      final envelope = ApiEnvelope<Map<String, dynamic>>.fromJson(
        response.data ?? const {},
        (value) => value as Map<String, dynamic>,
      );

      final items = envelope.extractItems<MonitoringRecord>(
        (value) => MonitoringRecord.fromJson(value as Map<String, dynamic>),
      );

      final metadata = envelope.metadata;
      return MonitoringPagedResult(
        items: items,
        totalPages: metadata?.totalPages ?? page,
        hasNext: metadata?.hasNext ?? false,
        page: metadata?.page ?? page,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final envelope = ApiEnvelope<dynamic>.fromJson(data, (value) => value);
        throw Exception(
          envelope.message.isNotEmpty
              ? envelope.message
              : MonitoringConstants.serviceFallbackError,
        );
      }
      throw Exception(MonitoringConstants.serviceFallbackError);
    }
  }
}

