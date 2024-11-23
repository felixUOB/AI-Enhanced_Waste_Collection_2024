import 'package:flutter/material.dart';

//Theme manager for controlling themeMode value
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