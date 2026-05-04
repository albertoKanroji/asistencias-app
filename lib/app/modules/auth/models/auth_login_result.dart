import 'auth_user.dart';

class AuthLoginResult {
  const AuthLoginResult({required this.user, required this.token});

  final AuthUser user;
  final String token;

  factory AuthLoginResult.fromJson(Map<String, dynamic> json) {
    return AuthLoginResult(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>? ?? const {}),
      token: json['token']?.toString() ?? '',
    );
  }
}
