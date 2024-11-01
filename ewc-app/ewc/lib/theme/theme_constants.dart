import 'package:ewc/imports/imports.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
    brightness: Brightness.light,
    surface: Colors.grey[300],
    )
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    primary: Colors.green,
    seedColor: Colors.black,
    brightness: Brightness.dark,
    surface: Colors.grey[900],
    
));