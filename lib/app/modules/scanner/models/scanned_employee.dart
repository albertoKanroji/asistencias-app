class ScannedEmployee {
  const ScannedEmployee({
    required this.id,
    required this.fullName,
    required this.position,
    required this.department,
    required this.curp,
    required this.hasPendingTc15Exit,
    this.image,
  });

  final int id;
  final String fullName;
  final String position;
  final String department;
  final String curp;
  final bool hasPendingTc15Exit;
  final String? image;

  static bool _parsePendingFlag(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }

  factory ScannedEmployee.fromJson(Map<String, dynamic> json) {
    return ScannedEmployee(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: json['nombre_completo']?.toString() ?? '',
      position: json['puesto']?.toString() ?? '',
      department: json['departamento']?.toString() ?? '',
      curp: json['curp']?.toString() ?? '',
      hasPendingTc15Exit: _parsePendingFlag(json['has_pending_tc15_exit']),
      image: json['image']?.toString(),
    );
  }
}
