import 'package:social/components/screens/posts/addpostscreen.dart';
import 'package:social/components/screens/posts/feedscreen.dart';
import "package:flutter/material.dart";

class Constants {
  static const tabWidgets = [FeedScreen(), AddPostScreen()];

  static const IconData up = IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down = IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);
}
