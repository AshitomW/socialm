import 'package:flutter/material.dart';
import 'package:social/components/widgets/button.dart';
import 'package:social/components/widgets/textfields.dart';
import 'package:social/core/images.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          const SizedBox(
            height: 25,
          ),
          const TextFields(
            hintText: "Email",
          ),
          const TextFields(
            hintText: "Password",
          ),
          // const SignInButton(labelString: "Sign In"),
          SignInButton(
            labelString: "Sign In With Google",
            imageUrl: Images.googleIcon,
          ),
        ],
      ),
    );
  }
}
