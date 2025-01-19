import 'package:flutter/material.dart';
import 'package:ewc/main.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Switch(value: themeManager.themeMode == ThemeMode.dark, onChanged: (onChanged){
      themeManager.toggleTheme(onChanged);
    });
  }
}