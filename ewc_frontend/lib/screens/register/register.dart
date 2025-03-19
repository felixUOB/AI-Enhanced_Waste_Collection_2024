import 'package:ewc/widgets/email_textfield.dart';
import 'package:ewc/widgets/password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:ewc/widgets/login_button.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/services/auth_service/auth_service.dart';

/// This file manages the register page and handles user registration.
///
/// Functions:
/// - `build()`: Builds the UI for the register page.
/// - `onPressed()`: Handles the registration logic.
/// - `onTap()`: Navigates to the login page.

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() {
    // TODO: implement createState
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage>{

  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  // Additional user information controllers
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final pickupFrequencyController = TextEditingController();
  final wasteTypePreferenceController = TextEditingController();
  final notificationPreferencesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            // Modified to enable scrolling
            child: Center(
              child: Column(
                children: [
                  // Logo and title
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "assets/RecycleNXT-Logo_Update_Black.png",
                    scale: 8,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an Account",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
      
                  // Username input field
                  LoginTextfield(
                    controller: usernameController,
                    hintText: "Username",
                    key: Key("usernameField"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
      
                  // Email input field
                  EmailTextfield(
                    controller: emailController,
                    hintText: "Email",
                    key: Key("emailField"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
      
                  // Password input field
                  PasswordTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    key: Key("passwordField"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
      
                  // Confirm Password input field
                  PasswordTextfield(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    key: Key("confirmPasswordField"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
      
                  // Register button
                  const SizedBox(
                    height: 20,
                  ),
                  LoginButton(
                    text1: "Register",
                    onPressed: () async {
                      // Check the form is valid and password verification 
                      if (passwordController.text == confirmPasswordController.text ) {
                        if (_formKey.currentState!.validate()){
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          try {
                            await AuthService().register(
                              username: usernameController.text,
                              password: passwordController.text,
                              email: emailController.text,
                            );
                            // Navigate to the login page after registration
                            // TODO: a pop up that says registration successful and takes you back a screen
                            navigator.pop;
                            
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: const Text("Success"),
                                content: const Text("Registration successful! Please log in"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      navigator.pop();
                                      navigator.pop();
                                    },
                                    child: const Text('OK')
                                  )
                                ],
                              )
                            );

                            
                          } catch (e) {
                            // Error handling
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('Registration failed: $e'),
                              ),
                            );
                          }
                        }
                      } else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Passwords do not match. Please try again.'),
                          ),
                        );
                        return;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
      
                  // Hyperlink to navigate to the login page
                  HyperLinkText(
                    string1: "Already have an account?",
                    hyperString: "Sign In.",
                    string2: "",
                    onTap: () {
                      Navigator.pop(context); // Navigate to login page
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
