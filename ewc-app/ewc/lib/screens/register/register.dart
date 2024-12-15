import 'package:flutter/material.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:ewc/widgets/login_button.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/api/auth_service.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

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
    return Scaffold(
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
                  obscured: false,
                  key: Key("usernameField"),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Email input field
                LoginTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscured: false,
                  key: Key("emailField"),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Password input field
                LoginTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscured: true,
                  key: Key("passwordField"),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Confirm Password input field
                LoginTextfield(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscured: true,
                  key: Key("confirmPasswordField"),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Additional user information input fields (optional)
                LoginTextfield(
                  controller: phoneNumberController,
                  hintText: "Phone Number",
                  obscured: false,
                  key: Key("phoneNumberField"),
                ),
                const SizedBox(
                  height: 10,
                ),

                LoginTextfield(
                  controller: addressController,
                  hintText: "Address",
                  obscured: false,
                  key: Key("addressField"),
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
                    // Add password verification logic
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Passwords do not match. Please try again.'),
                        ),
                      );
                      return;
                    }
                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    try {
                      await AuthService().register(
                        username: usernameController.text,
                        password: passwordController.text,
                        email: emailController.text,
                        phoneNumber: phoneNumberController.text,
                        address: addressController.text,
                        // Include additional fields if necessary
                      );
                      // Navigate to the login page after registration
                      navigator.pop;
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content:
                              Text('Registration successful! Please log in.'),
                        ),
                      );
                    } catch (e) {
                      // Error handling
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Registration failed: $e'),
                        ),
                      );
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
    );
  }
}
