import 'package:ewc/screens/login/forgot-password.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/login/register-user.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/theme/theme_manager.dart';
import 'package:flutter/material.dart';

ThemeManager themeManager = ThemeManager();

void main() => runApp(const App()); //Runs application root

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() { //Creates initial state of app
    return myAppState();
  }
}

class myAppState extends State<App>{

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
      home: RegisterUser(),
      //home: LoginPage(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode
    );
  }
}