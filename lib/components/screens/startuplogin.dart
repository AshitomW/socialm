import 'package:flutter/material.dart';

import 'package:social/components/screens/auth/loginscreen.dart';
import 'package:social/components/screens/auth/registerscreen.dart';
import 'package:social/themes/colorscheme.dart';

class Startuplogin extends StatefulWidget {
  const Startuplogin({super.key});

  @override
  State<Startuplogin> createState() => _StartuploginState();
}

class _StartuploginState extends State<Startuplogin> {
  List<Widget> pages = const [
    LoginScreen(),
    Registerscreen(),
  ];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colorscheme.drawerColor,
        currentIndex: currentPage,
        selectedFontSize: 15,
        unselectedFontSize: 10,
        iconSize: 26,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Login",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: "Register",
          )
        ],
      ),
    );
  }
}
