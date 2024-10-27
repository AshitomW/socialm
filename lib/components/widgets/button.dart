import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String labelString;

  final String? imageUrl;
  const SignInButton({super.key, required this.labelString, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {},
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
