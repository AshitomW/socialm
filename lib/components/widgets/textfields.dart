import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  final String hintText;
  const TextFields({
    super.key,
    required this.hintText,
    this.emailController,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
