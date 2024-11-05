import 'package:ewc/imports/imports.dart';

const spaceNXTGreen = Color.fromARGB(255, 32, 156, 132);
//Section to create default theme for application - needs further input from team
ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    primary: spaceNXTGreen,
    seedColor: Colors.white,
    brightness: Brightness.light,
    surface: Colors.grey[300],
    ),
    textTheme: const TextTheme(
       bodyMedium: TextStyle(
        color: Colors.black,
        fontFamily: "Questrial",
        fontSize: 15,
       ),
       bodySmall: TextStyle(
        color: Colors.black,
        fontFamily: "Questrial",
        fontSize: 13,
       ),
       bodyLarge: TextStyle(
        color: Colors.black,
        fontFamily: "Questrial",
        fontSize: 17,
       ),
    )
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    primary: spaceNXTGreen,
    seedColor: Colors.black,
    brightness: Brightness.dark,
    surface: Colors.grey[900],
  ),
  textTheme: const TextTheme(
       bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: "Questrial",
        fontSize: 15,
       ),
       bodySmall: TextStyle(
        color: Colors.white,
        fontFamily: "Questrial",
        fontSize: 13,
       ),
       bodyLarge: TextStyle(
        color: Colors.white,
        fontFamily: "Questrial",
        fontSize: 17,
       ),
  )
);