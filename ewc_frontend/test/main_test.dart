import 'dart:async';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/theme/theme_manager.dart';
import 'package:flutter/material.dart';

ThemeManager themeManager = ThemeManager();

// so that test code can 'await' this function call.
Future<void> main({Completer<void>? setupCompleter}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // If no completer is provided, call setupLocator().
  if (setupCompleter == null) {
    await setupLocator();
  }

  // If a completer is given, we skip setupLocator() but do .complete() instead.
  setupCompleter?.complete();

  // runApp does not return anything (void), but because this function is now
  // async, the test can wait for all async tasks to complete (including setup).
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    //Creates initial state of the app
    return MyAppState();
  }
}

class MyAppState extends State<App> {
  @override
  void dispose() {
    //When State closes this function is called to remove the theme listener
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    //Initialising App State with a listener
    themeManager.addListener(themeListener);
    super.initState();
  }

  void themeListener() {
    //English comment: if the widget is still mounted, we re-build the UI
    //so that the updated theme takes effect
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //English comment: The main build method that sets up the MaterialApp
    //with our splash page and theme references
    return MaterialApp(
        title: "EWC",
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        // theme management
        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: themeManager.themeMode
    );
  }
}