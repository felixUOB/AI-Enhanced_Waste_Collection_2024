import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/encryption_service.dart';
import 'package:flutter/material.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:ewc/widgets/login_button.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/widgets/theme_switch.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/screens/register/register.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:ewc/widgets/password_textfield.dart';

/// This file manages the user authentication and login functionality.
///
/// Functions:
/// - `build()`: Builds the UI for the login page.

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;

  final AuthService _authService = getIt<AuthService>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Stack(children: [
      Center(
        child: Column(
          children: [
            //-------------RECYCLENXT LOGO----------------------
            const SizedBox(
              height: 170,
            ),
            Image.asset(
              key: ValueKey("logo"),
              "assets/RecycleNXT-Logo_Update_Black.png",
              scale: 8,
            ),
            //-------------WELCOME BACK TXT-FIELD----------------------
            const SizedBox(
              height: 50,
            ),
            Text(
              "Welcome Back!",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 30,
            ),

            //-------------USERNAME TXT-FIELD----------------------
            LoginTextfield(
              controller: usernameController,
              hintText: "Username",
              key: Key("usernameField"),
            ),
            const SizedBox(
              height: 10,
            ),

            //-------------PASSWORD TXT-FIELD----------------------
            PasswordTextfield(
              controller: passwordController,
              hintText: "Password",
              key: Key("passwordField"),
            ),

            //-------------HYPERLINK: FORGOT PASSWORD----------------------
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Remember Me?"),
                          Checkbox(
                              key: Key("remember_me"),
                              value: _rememberMe,
                              onChanged: (value) => setState(() {
                                    _rememberMe = value!;
                                  })),
                        ],
                      ),
                      HyperLinkText(
                          string1: "",
                          hyperString: "Forgot Password?",
                          string2: "",
                          onTap: _authService.launchPasswordReset),
                    ])),

            //-------------LOGIN BUTTON---------------------------------
            const SizedBox(
              height: 20,
            ),
            LoginButton(
              key: Key("loginButtonTop"), // Add a unique key
              text1: "Sign In",
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                  await _authService.login(
                      usernameController.text, EncryptionService().hashData(passwordController.text));
                  // Navigate to the schedule page after successful login

                  if (_rememberMe) {
                    await _authService.saveUserCredentials(
                        usernameController.text, EncryptionService().hashData(passwordController.text));
                  }
                  // Navigate to home screen
                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainNavigationBar(
                        testing: false,
                      ), // Moving pages
                    ),
                  );
                } catch (e) {
                  // Error handling: for example, display a warning message to the user if login fails
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Login failed: $e'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),

            //-------------HYPERLINK: REGISTER-------------------------------------
            HyperLinkText(
              string1: "Not a member?",
              hyperString: "Register Here.",
              string2: "",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(
                      key: ValueKey("registerPage"),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      //----------------THEME SWITCH------------------------------
      Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.all(25),
              child: Align(
                alignment: Alignment.topRight,
                child: ThemeSwitch(),
              ))
        ],
      )
    ]))));
  }
}
