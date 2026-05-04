class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.data,
    required this.status,
    required this.message,
    this.metadata,
    this.error,
  });

  final List<T> data;
  final int status;
  final String message;
  final ApiMetadata? metadata;
  final ApiError? error;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic value) mapper,
  ) {
    final rawData = (json['data'] as List<dynamic>? ?? const []);
    final mappedData = rawData.map(mapper).toList();

    ApiMetadata? metadata;
    if (rawData.isNotEmpty && rawData.first is Map<String, dynamic>) {
      final first = rawData.first as Map<String, dynamic>;
      final rawMetadata = first['metadata'];
      if (rawMetadata is Map<String, dynamic>) {
        metadata = ApiMetadata.fromJson(rawMetadata);
      }
    }

    final rawError = json['error'];

    return ApiEnvelope<T>(
      data: mappedData,
      status: (json['status'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      metadata: metadata,
      error: rawError is Map<String, dynamic> ? ApiError.fromJson(rawError) : null,
    );
  }

  List<R> extractItems<R>(R Function(dynamic value) mapper) {
    if (data.isEmpty) {
      return const [];
    }

    final first = data.first;
    if (first is! Map<String, dynamic>) {
      return const [];
    }

    final rawItems = first['items'];
    if (rawItems is! List) {
      return const [];
    }

    return rawItems.map(mapper).toList();
  }
}

class ApiMetadata {
  const ApiMetadata({
    required this.page,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    this.search,
    this.filters,
  });

  final int page;
  final int pageSize;
  final int totalRecords;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final String? search;
  final Map<String, dynamic>? filters;

  factory ApiMetadata.fromJson(Map<String, dynamic> json) {
    return ApiMetadata(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
      totalRecords: (json['totalRecords'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
      search: json['search']?.toString(),
      filters: json['filters'] as Map<String, dynamic>?,
    );
  }
}

class ApiError {
  const ApiError({
    required this.code,
    required this.type,
    required this.exception,
    this.stackTrace,
    this.traceId,
    this.environment,
  });

  final String code;
  final String type;
  final String exception;
  final String? stackTrace;
  final String? traceId;
  final String? environment;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code']?.toString() ?? 'ERROR',
      type: json['type']?.toString() ?? 'ApplicationError',
      exception: json['exception']?.toString() ?? 'Unexpected error',
      stackTrace: json['stack_trace']?.toString(),
      traceId: json['trace_id']?.toString(),
      environment: json['environment']?.toString(),
    );
  }
}
