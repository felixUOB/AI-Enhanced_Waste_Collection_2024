import 'package:ewc/imports/imports.dart';
import 'package:ewc/api/auth_service.dart'; // Add AuthService import
import 'package:flutter/material.dart';
import 'package:ewc/screens/route-schedule/schedule.dart'; // Import Schedule Page


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // TXT Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [

                  //-------------RECYCLENXT LOGO----------------------
                  const SizedBox(height: 170,),
                  Image.asset(
                    "assets/RecycleNXT-Logo_Update_Black.png",
                    scale: 8,
                  ),

                  //-------------WELCOME BACK TXT-FIELD----------------------
                  const SizedBox(height: 50,),
                  Text(
                    "Welcome Back!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 30,),

                  //-------------USERNAME TXT-FIELD----------------------
                  LoginTextfeild(
                    controller: usernameController,
                    hintText: "Username",
                    obscured: false,
                  ),
                  const SizedBox(height: 10,),

                  //-------------PASSWORD TXT-FIELD----------------------
                  LoginTextfeild(
                    controller: passwordController,
                    hintText: "Password",
                    obscured: true,
                  ),

                  //-------------HYPERLINK: FORGOT PASSWORD----------------------
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        HyperLinkText(
                          string1: "",
                          hyperString: "Forgot Password?",
                          string2: "",
                          link: Uri.parse("https://en.wikipedia.org/wiki/Lamia"), // Link to password reset function
                        )
                      ],
                    )
                  ),

                  //-------------LOGIN BUTTON---------------------------------
                  const SizedBox(height: 20,),
                  LoginButton(
                    text1: "Sign In",
                    onPressed: () async {
                      try {
                        await AuthService().login(
                          usernameController.text,
                          passwordController.text
                        );
                        // Navigate to the schedule page after successful login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Schedule(), // Moving pages
                          ),
                      } catch (e) {
                        // Error handling: for example, display a warning message to the user if login fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login failed: $e'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10,),

                  //-------------HYPERLINK: REGISTER-------------------------------------
                  HyperLinkText(
                    string1: "Not a member?",
                    hyperString: "Register Here.",
                    string2: "",
                    link: Uri.parse("https://spacenxtlabs.com"), // Link to registration function
                  ),
                ],
              ),
            ),

            //----------------THEME SWITCH------------------------------
            Column(
              children: [
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child:
                    Align(
                      alignment: Alignment.topRight,
                      child: ThemeSwitch(),
                    )
                )
              ],
            )
          ]
        )
      )
    );
  }
}
