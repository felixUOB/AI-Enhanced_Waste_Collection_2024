import 'package:ewc/imports/imports.dart';
import 'package:ewc/api/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
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
        child: SingleChildScrollView( // Modified to enable scrolling
          child: Center(
            child: Column(
              children: [
                // Logo and title
                const SizedBox(height: 50,),
                Image.asset(
                  "assets/RecycleNXT-Logo_Update_Black.png",
                  scale: 8,
                ),
                const SizedBox(height: 20,),
                Text(
                  "Create an Account",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 30,),

                // Username input field
                LoginTextfeild(
                  controller: usernameController,
                  hintText: "Username",
                  obscured: false,
                ),
                const SizedBox(height: 10,),

                // Email input field
                LoginTextfeild(
                  controller: emailController,
                  hintText: "Email",
                  obscured: false,
                ),
                const SizedBox(height: 10,),

                // Password input field
                LoginTextfeild(
                  controller: passwordController,
                  hintText: "Password",
                  obscured: true,
                ),
                const SizedBox(height: 10,),

                // Additional user information input fields (optional)
                LoginTextfeild(
                  controller: phoneNumberController,
                  hintText: "Phone Number",
                  obscured: false,
                ),
                const SizedBox(height: 10,),

                LoginTextfeild(
                  controller: addressController,
                  hintText: "Address",
                  obscured: false,
                ),
                const SizedBox(height: 10,),

                // Register button
                const SizedBox(height: 20,),
                LoginButton(
                  text1: "Register",
                  onPressed: () async {
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
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration successful! Please log in.'),
                        ),
                      );
                    } catch (e) {
                      // Error handling
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration failed: $e'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10,),

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
