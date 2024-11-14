import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class LoginTextfeild extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final bool obscured;

  LoginTextfeild({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscured,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Theme(
          data: ThemeData.light(),
          child: TextField(
            controller: controller,
            obscureText: obscured,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
              ),
              fillColor: const Color.fromARGB(250, 240, 240, 240),
              filled: true,
              hintText: hintText,
              hintStyle: AppTheme().hiddenTextStyleMedium,
              )
          ),
        ),
    );
    
  }
}
