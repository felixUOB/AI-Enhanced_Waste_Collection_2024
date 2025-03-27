import 'dart:async';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


/// This file manages the main app state and provides the entry point for the app.
///
/// Functions:
/// - `main()`: Initializes the app and runs the material app
/// - `themeListener()`: Updates the app state on theme changes
/// - `initState()`: Initializes the app state
/// - `dispose()`: Disposes the app state

ThemeManager themeManager = ThemeManager();

void main({Completer<void>? setupCompleter}) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (setupCompleter == null) {
    await setupLocator();
  }

  setupCompleter?.complete();

  await Hive.initFlutter(); // Initializes Hive for Flutter apps
  await Hive.openBox('Settings');//open up storage box

  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    //Creates initial state of app
    return MyAppState();
  }
}

class MyAppState extends State<App> {
//When State closes this function is called to remove listener
  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

//Initialising App State with a listener
  @override
  void initState() {
    themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  // main build method
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "EWC",
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        // theme management
        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: themeManager.themeMode);
  }
}
