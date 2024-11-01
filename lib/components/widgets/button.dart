import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social/components/controllers/authcontroller.dart';

class SignInButton extends ConsumerWidget {
  final String labelString;
  final bool isFromLogIn;
  final String? imageUrl;
  const SignInButton(
      {super.key, required this.labelString, this.imageUrl, this.isFromLogIn = true});

  void signIn(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context, isFromLogIn);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () => signIn(ref, context),
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
