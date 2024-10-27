import 'package:flutter/material.dart';

import 'package:social/components/widgets/button.dart';
import 'package:social/components/widgets/textfields.dart';

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          SizedBox(height: 50),
          Icon(
            Icons.account_circle_sharp,
            size: 150,
          ),
          SizedBox(height: 50),
          Text(
            "Register to get Experience!",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          TextFields(
            hintText: "Email",
          ),
          TextFields(
            hintText: "Password",
          ),
          TextFields(
            hintText: "Confirm Password",
          ),
          SignInButton(labelString: "Register"),
        ],
      ),
    );
  }
}
