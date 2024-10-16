import 'package:flutter/material.dart';

class LoginTextfeild extends StatelessWidget {
  const LoginTextfeild({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      fillColor: Color.fromARGB(250, 240, 240, 240),
                      filled: true
                    ),
                  ),
              );
  }
}