import '../../../core/services/auth_service.dart';
import '../models/login_request.dart';

class LoginService {
  LoginService(this._authService);

  final AuthService _authService;

  Future<bool> signIn(LoginRequest request) {
    return _authService.login(
      username: request.username,
      password: request.password,
    );
  }
}
