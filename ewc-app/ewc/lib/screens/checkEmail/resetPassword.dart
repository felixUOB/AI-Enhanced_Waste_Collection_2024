

import 'package:ewc/imports/imports.dart';
import 'package:ewc/api/auth_service.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

    final newPasswordController = TextEditingController();
    final newPasswordConfirmController = TextEditingController();


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
                    "Please enter new password.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20,),

                  //-------------PASSWORD RESET----------------------
                  LoginTextfeild(
                    controller: newPasswordController,
                    hintText: "New Password",
                    obscured: false,
                  ),
                  const SizedBox(height: 10,),

                  //-------------PASSWORD RESET CHECK----------------------
                  LoginTextfeild(
                    controller: newPasswordConfirmController,
                    hintText: "Confirm New Password",
                    obscured: false,
                  ),
                  const SizedBox(height: 20,),

                  //-------------SEND EMAIL RESET BUTTON---------------------------------

                  const SizedBox(height: 20,),
                  LoginButton(
                    text1: "Change Password",
                    onPressed: () async {
                      if (newPasswordController.text == newPasswordConfirmController.text){
                        print("DEVELOPMENT PRINT");

                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords dont match.'),
                          ));
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
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