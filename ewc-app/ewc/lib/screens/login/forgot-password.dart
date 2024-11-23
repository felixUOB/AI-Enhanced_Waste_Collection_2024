import '../register/register.dart';
import 'package:flutter/material.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:ewc/widgets/login_button.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/widgets/theme_switch.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword>{
  //TXT Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                    "Reset your password!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
            
                  const SizedBox(height: 30,),
            
//-------------USERNAME TXT-FIELD----------------------
            
                  //username txtfld
                  LoginTextfield(
                    controller: usernameController,
                    hintText: "Email",
                    obscured: false,
                  ),
            
                  const SizedBox(height: 10,),
            
//-------------PASSWORD TXT-FIELD----------------------
                  if (isVisible)
                    LoginTextfield(
                      controller: passwordController,
                      hintText: "Password",
                      obscured: true,
                    ),
            
//-------------HYPERLINK-------------------------------
            
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        HyperLinkText(
                          string1: "",
                          hyperString: "Already a user?", 
                          string2: "",
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                    ),

//-------------LOGIN BUTTON---------------------------------

                  LoginButton(
                    text1: "Reset Password",
                    // function that sends a request to reset the password
                    onPressed: (){
                      // refresh the page to make the password field visible
                      // check to see if the email entered is registered in the database
                      // if it is
                      setState(() {
                        isVisible = true; // make the password field visible and update the database
                      });
                      print("button pressed");
                      print(usernameController.text);
                    },
                  ),
                  const SizedBox(height: 10,),

//-------------HYPERLINK-------------------------------------

                  HyperLinkText(
                    string1: "Not a member?",
                    hyperString: "Register Here.",
                    string2: "",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
//----------------THEME SWITCH------------------------------
            // ignore: prefer_const_constructors
            Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const SizedBox(height: 20,),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.all(25),
                  child:
                    // ignore: prefer_const_constructors
                    Align(
                      alignment: Alignment.topRight, 
                      // ignore: prefer_const_constructors
                      child: ThemeSwitch(),
                    )
                )
          ],)
        ]),
      )
    )
    );     
  }
}
