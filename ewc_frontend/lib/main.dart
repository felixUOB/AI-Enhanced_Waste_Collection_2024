import 'dart:async';

import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:ewc/services/auth_service.dart';

ThemeManager themeManager = ThemeManager();

void main({Completer<void>? setupCompleter, bool? testing}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  setupCompleter?.complete();

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
