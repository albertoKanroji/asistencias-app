class MonitoringFilters {
  const MonitoringFilters({
    this.search,
    this.userId,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  final String? search;
  final int? userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? sortBy;
  final String? sortOrder;

  bool get hasAny =>
      (search != null && search!.trim().isNotEmpty) ||
      userId != null ||
      startDate != null ||
      endDate != null ||
      (sortBy != null && sortBy!.isNotEmpty) ||
      (sortOrder != null && sortOrder!.isNotEmpty);

  Map<String, dynamic> toQuery({required int page, required int pageSize}) {
    return {
      'page': page,
      'pageSize': pageSize,
      if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
      if (userId != null) 'user_id': userId,
      if (startDate != null) 'start_date': startDate!.toIso8601String(),
      if (endDate != null) 'end_date': endDate!.toIso8601String(),
      if (sortBy != null && sortBy!.isNotEmpty) 'sortBy': sortBy,
      if (sortOrder != null && sortOrder!.isNotEmpty) 'sortOrder': sortOrder,
    };
  }
}
