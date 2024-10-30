import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social/core/enums.dart';
import 'package:social/themes/colorscheme.dart';

final themeDataProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  Thememode _mode;

  Thememode get currentTheme => _mode;

  ThemeNotifier({Thememode mode = Thememode.dark})
      : _mode = mode,
        super(Colorscheme.darkModeAppTheme) {
    getTheme();
  }
  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString("theme");

    if (theme == "light") {
      _mode = Thememode.light;
      state = Colorscheme.lightModeAppTheme;
    } else {
      _mode = Thememode.dark;
      state = Colorscheme.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_mode == Thememode.dark) {
      _mode = Thememode.light;
      state = Colorscheme.lightModeAppTheme;
      prefs.setString("theme", "light");
    } else {
      _mode = Thememode.dark;
      state = Colorscheme.darkModeAppTheme;
      prefs.setString("theme", "dark");
    }
  }
}
