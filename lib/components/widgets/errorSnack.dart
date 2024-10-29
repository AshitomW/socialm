import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showSnackBar(BuildContext context, String text) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      // Ensures context is valid
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(text),
        ));
    }
  });
}
