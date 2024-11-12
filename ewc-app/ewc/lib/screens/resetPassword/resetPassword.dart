

import 'package:ewc/imports/imports.dart';
import 'package:ewc/api/auth_service.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

    final emailController = TextEditingController();

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
                    "Reset Password!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 30,),

                  //-------------USERNAME TXT-FIELD----------------------
                  LoginTextfeild(
                    controller: emailController,
                    hintText: "Email",
                    obscured: false,
                  ),
                  const SizedBox(height: 20,),

                  //-------------SEND EMAIL RESET BUTTON---------------------------------

                  const SizedBox(height: 20,),
                  LoginButton(
                    text1: "Send Reset Link",
                    onPressed: () async {
                      try {
                        var responseBool = await AuthService().checkEmailString(
                         emailController.text
                        );
                        if (responseBool){
                          print("DEVELOPMENT PRINT");
                          //ADD FUNCTIONALITY TO SEND RESET EMAIL TO REGISTERED EMAIL
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No account registered to email.'),
                          ));
                        }
                      } catch (e) {
                        // Error handling: for example, display a warning message to the user if login fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email Error: $e'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10,),

                  //-------------HYPERLINK: REGISTER-------------------------------------
                  HyperLinkText(
                    string1: "Remembered Password?",
                    hyperString: "Back to Login.",
                    string2: "",
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
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