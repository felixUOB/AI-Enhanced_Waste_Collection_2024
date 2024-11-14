

import 'package:ewc/imports/imports.dart';
import 'package:ewc/api/auth_service.dart';
import 'package:ewc/screens/checkEmail/resetPassword.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:flutter/material.dart';

class CheckEmailPage extends StatelessWidget {
  CheckEmailPage({super.key});

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

                  //-------------EMAIL INFO TXT-FIELD----------------------
                  const SizedBox(height: 50,),
                  Text(
                    "Please enter email associated with your account.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20,),

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
                        var responseBool = await AuthService().checkEmail(
                         emailController.text
                        );
                        if (responseBool){
                          await launchPasswordReset();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No account registered to email.'),
                          ));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Request unsuccessful. Details: $e'),
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

Future<void> launchPasswordReset() async {
    final Uri resetUri = Uri.parse("http://127.0.0.1:8000/reset_password/");
  
  if (await canLaunchUrl(resetUri)) {
    print("LAUNCHING");
    await launchUrl(resetUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch password reset URL';
  }
}