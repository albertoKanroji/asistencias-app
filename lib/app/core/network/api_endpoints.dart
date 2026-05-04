class ApiEndpoints {
  ApiEndpoints._();

  static const auth = _AuthEndpoints();
  static const extraordinary = _ExtraordinaryEndpoints();
  static const employees = _EmployeeEndpoints();
}

class _AuthEndpoints {
  const _AuthEndpoints();

  final String login = '/auth/login';
  final String refresh = '/auth/refresh';
  final String profile = '/auth/profile';
  final String logout = '/auth/logout';
}

class _ExtraordinaryEndpoints {
  const _ExtraordinaryEndpoints();

  final String registerEvent = '/extraordinary-movements/register-event';
  final String entries = '/extraordinary-movements/entries';
  final String exits = '/extraordinary-movements/exits';
  final String pending = '/extraordinary-movements/pending';
}

class _EmployeeEndpoints {
  const _EmployeeEndpoints();

  String byCurp(String curp) => '/employees/curp/$curp';
}
