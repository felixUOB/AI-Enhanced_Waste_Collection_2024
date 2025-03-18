import 'package:flutter/material.dart';

/// This file manages the theme for the app.
///
/// Functions:
/// - `toggleTheme(bool dark)`: Toggles the theme between light and dark.

class ThemeManager with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  toggleTheme(bool dark){ 
    if (dark == true){
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

}