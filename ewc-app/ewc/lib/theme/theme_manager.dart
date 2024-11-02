import 'package:ewc/imports/imports.dart';

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