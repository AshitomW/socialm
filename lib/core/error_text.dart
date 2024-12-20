// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String error;
  const ErrorText({super.key, required this.error});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
