import "package:social/components/services/auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final authControllerProvider = Provider(
  (ref) => AuthController(
    authService: ref.read(authServiceProvider),
  ),
);

class AuthController {
  final AuthService _authService;
  AuthController({required AuthService authService}) : _authService = authService;

  void signInWithGoogle() {
    _authService.signInWithGoogle();
  }
}
