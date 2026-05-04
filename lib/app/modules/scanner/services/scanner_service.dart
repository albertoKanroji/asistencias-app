import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/models/api_envelope.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../constants/scanner_constants.dart';
import '../models/scanned_employee.dart';

class ScannerService {
  ScannerService(this._apiClient);

  final ApiClient _apiClient;

  Future<String> getData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ScannerConstants.readyMessage;
  }

  Future<ScannedEmployee?> getEmployeeByCurp(String curp) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        ApiEndpoints.employees.byCurp(curp),
      );

      final envelope = ApiEnvelope<ScannedEmployee>.fromJson(
        response.data ?? const {},
        (value) => ScannedEmployee.fromJson(value as Map<String, dynamic>),
      );

      if (envelope.data.isEmpty) {
        return null;
      }

      return envelope.data.first;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final envelope = ApiEnvelope<dynamic>.fromJson(data, (value) => value);
        throw Exception(
          envelope.message.isNotEmpty
              ? envelope.message
              : ScannerConstants.scannerServiceError,
        );
      }
      throw Exception(ScannerConstants.scannerServiceError);
    }
  }

  Future<void> registerMovement({required Map<String, dynamic> payload}) async {
    debugPrint(
      'POST ${ApiEndpoints.extraordinary.registerEvent} body: $payload',
    );

    try {
      await _apiClient.dio.post<Map<String, dynamic>>(
        ApiEndpoints.extraordinary.registerEvent,
        data: payload,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final envelope = ApiEnvelope<dynamic>.fromJson(data, (value) => value);
        throw Exception(
          envelope.message.isNotEmpty
              ? envelope.message
              : ScannerConstants.registerServiceError,
        );
      }
      throw Exception(ScannerConstants.registerServiceError);
    }
  }
}

