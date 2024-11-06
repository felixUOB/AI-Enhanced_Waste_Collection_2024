import 'package:ewc/imports/imports.dart';

const spaceNXTGreen = Color.fromARGB(255, 32, 156, 132);

//----------------VARIABLE THEMES - LIGHT AND DARK----------------------------

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

//------------SECTION FOR CONSTANT TEXT COLOURS--------------------

const constWhiteTextMedium = TextStyle(
  color: Colors.white,
  fontFamily: "Questrial",
  fontSize: 15,
);

const constBlackTextMedium = TextStyle(
  color: Colors.black,
  fontFamily: "Questrial",
  fontSize: 15,
);

final hiddenTextStyleMedium = TextStyle(
  color: Colors.grey[400],
  fontFamily: "Questrial",
  fontSize: 15,
);

const hyperLinkTextStyleMedium = TextStyle(
  color: Colors.blue,
  fontFamily: "Questrial",
  fontSize: 15,
);