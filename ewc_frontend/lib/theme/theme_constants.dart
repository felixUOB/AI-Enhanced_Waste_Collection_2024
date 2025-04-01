import 'package:flutter/material.dart';

/// This file contains the theme constants for the app.
///
/// Functions:
/// - `lightTheme`: Returns the light theme for the app.
/// - `darkTheme`: Returns the dark theme for the app.

const spaceNXTGreen = Color.fromARGB(255, 32, 156, 132);
const spaceNXTGreenLight = Color.fromARGB(255, 147, 175, 173);

class AppTheme {
  ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      primary: spaceNXTGreen,
      secondary: spaceNXTGreenLight,
      seedColor: Colors.white,
      brightness: Brightness.light,
      surface: Colors.grey[300],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        overlayColor: Colors.white,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
    ),
    textTheme: TextTheme(
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
      titleMedium: TextStyle(
        color: Colors.black,
        fontFamily: "Questrial",
        fontWeight: FontWeight.w700,
        fontSize: 20.0
      ),
      titleLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 30.0
      ),
    ),
  );

  ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      primary: spaceNXTGreen,
      secondary: spaceNXTGreenLight,
      seedColor: Colors.black,
      brightness: Brightness.dark,
      surface: Colors.grey[900],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        overlayColor: Colors.black,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
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
      titleMedium: TextStyle(
        color: Colors.white,
        fontFamily: "Questrial",
        fontWeight: FontWeight.w700,
        fontSize: 20.0),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 30.0)
    ),
  );

  //------------SECTION FOR CONSTANT TEXT COLOURS--------------------

  final constWhiteTextSmall = TextStyle(
    color: Colors.white,
    fontFamily: "Questrial",
    fontSize: 12,
  );

  final constWhiteTextMedium = TextStyle(
    color: Colors.white,
    fontFamily: "Questrial",
    fontSize: 15,
  );

  final constWhiteTextLarge = TextStyle(
    color: Colors.white,
    fontFamily: "Questrial",
    fontSize: 20,
  );

  final constBlackTextMedium = TextStyle(
    color: Colors.black,
    fontFamily: "Questrial",
    fontSize: 15,
  );

  final hiddenTextStyleMedium = TextStyle(
    color: Colors.grey[400],
    fontFamily: "Questrial",
    fontSize: 15,
  );

  final hyperLinkTextStyleMedium = TextStyle(
    color: Colors.blue,
    fontFamily: "Questrial",
    fontSize: 15,
  );
}
