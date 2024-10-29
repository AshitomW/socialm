import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social/components/controllers/authcontroller.dart';

import 'package:social/core/images.dart';
import 'package:social/components/widgets/button.dart';

import 'package:social/core/loader.dart';

class Startuplogin extends ConsumerWidget {
  const Startuplogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: !isLoading
          ? SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Welcome back you've been missed !",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),

                  // const SignInButton(labelString: "Sign In"),
                  SignInButton(
                    labelString: "Sign In With Google",
                    imageUrl: Images.googleIcon,
                  ),
                  const Spacer(),
                ],
              ),
            )
          : const Loader(),
    );
  }
}
