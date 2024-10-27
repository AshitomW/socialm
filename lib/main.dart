import 'package:flutter/material.dart';

import 'package:social/components/screens/startuplogin.dart';
import 'package:social/themes/colorscheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Social Media",
      theme: Colorscheme.darkModeAppTheme,
      home: const Startuplogin(),
    );
  }
}
