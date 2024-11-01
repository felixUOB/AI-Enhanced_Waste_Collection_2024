import 'package:ewc/imports/imports.dart';

class ThemeManager with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  getThemeMode(){
    return themeMode;
  }


  toggleTheme(bool isDark){
    if (isDark == true){
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

}