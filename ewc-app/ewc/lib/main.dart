import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'screens/login/login.dart';

ThemeManager themeManager = ThemeManager();

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    return myAppState();
  }
}

class myAppState extends State<App>{

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener(){
    if (mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EWC",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode
    );
  }
}