import 'package:flutter/material.dart';
import 'package:ewc/widgets/login_textfeild.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),

              // Lock Logo
              Icon(Icons.lock,
                size: 100,
              ),

              //'Welcome back'
              SizedBox(height: 50,),
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 18,
                )
              ),

              SizedBox(height: 30,),

              //username txtfld
              LoginTextfeild(),

              SizedBox(height: 10,),

              //password txtfld
              LoginTextfeild(),
              //'forgot password?'

              //not a member, register now

            ],
          ),
        ),
      ),
    );     
  }
}