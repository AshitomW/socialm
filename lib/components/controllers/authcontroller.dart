import "package:flutter/widgets.dart";
import "package:social/components/services/auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/widgets/errorSnack.dart";

final authControllerProvider = Provider(
  (ref) => AuthController(
    authService: ref.read(authServiceProvider),
  ),
);

class AuthController {
  final AuthService _authService;
  AuthController({required AuthService authService}) : _authService = authService;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authService.signInWithGoogle();
    user.fold((failure) => showSnackBar(context, failure.message), (right) => null);
  }
}
