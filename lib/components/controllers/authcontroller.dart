import "package:flutter/widgets.dart";
import "package:social/components/services/auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:social/components/widgets/errorSnack.dart";
import "package:social/components/model/usermodel.dart";
import "package:firebase_auth/firebase_auth.dart";

final userDataProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthService _authService;
  final Ref _ref;
  AuthController({required AuthService authService, required Ref ref})
      : _authService = authService,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authService.authStateChange;

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authService.signInWithGoogle(isFromLogin);
    state = false;
    user.fold(
      (failure) => showSnackBar(context, failure.message),
      (userModel) => _ref.read(userDataProvider.notifier).update((state) => userModel),
    );
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authService.signInAsGuest();
    state = false;
    user.fold(
      (failure) => showSnackBar(context, failure.message),
      (userModel) => _ref.read(userDataProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authService.getUserData(uid);
  }

  void logOut() async {
    _authService.logOut();
  }
}
