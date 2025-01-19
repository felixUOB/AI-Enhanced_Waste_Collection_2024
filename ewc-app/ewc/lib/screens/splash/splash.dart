import 'package:ewc/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:ewc/api/auth_service.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';

// SplashPage is the initial screen that attempts auto-login
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _attemptAutoLogin();
  }

  // Attempts to auto-login using saved credentials
  void _attemptAutoLogin() async {
    // await _authService.clearCredentials();
    var credentials = await _authService.loadUserCredentials();

    String? username = credentials['username'];
    String? password = credentials['password'];

    if (username != null && password != null) {
      try {
        await _authService.login(
            username, password); // Attempt login with given credentials

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainNavigationBar(
                testing: false,
              ), // Moving pages
            ),
          );
        }
      } catch (e) {
        // If unsuccessful, route to login page
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(), // Moving pages
            ),
          );
        }
      }
      // If either username or password is null, skip check and route to Login
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(), // Moving pages
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/RecycleNXT-Logo_Update_Black.png",
            scale: 8,
          ),
          SizedBox(
            height: 50,
          ),
          CircularProgressIndicator()
        ],
      ),
    )));
  }
}
