import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social/components/controllers/authcontroller.dart';

class SignInButton extends ConsumerWidget {
  final String labelString;
  final String? imageUrl;
  const SignInButton({super.key, required this.labelString, this.imageUrl});

  void signIn(WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle(ref.context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () => signIn(ref),
        label: Text(
          labelString,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        icon: imageUrl != null
            ? Image.asset(
                imageUrl!,
                width: 30,
              )
            : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
