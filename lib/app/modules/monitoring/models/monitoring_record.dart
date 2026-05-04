class MonitoringRecord {
  const MonitoringRecord({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.type,
    required this.date,
    required this.time,
    this.status,
    this.reason,
    this.image,
    this.device,
  });

  final int id;
  final int userId;
  final String fullName;
  final String type;
  final String date;
  final String time;
  final String? status;
  final String? reason;
  final String? image;
  final String? device;

  factory MonitoringRecord.fromJson(Map<String, dynamic> json) {
    return MonitoringRecord(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      fullName: json['full_name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString(),
      reason: json['reason']?.toString(),
      image: json['image']?.toString(),
      device: json['device']?.toString(),
    );
  }
}
