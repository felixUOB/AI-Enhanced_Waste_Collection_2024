import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';

/// This file manages the login textfield widget.
///
/// Functions:
/// - `build()`: Builds the login textfield component.

class LoginTextfield extends StatelessWidget {
  final dynamic controller;
  final String hintText;

  // ignore: prefer_const_constructors_in_immutables
  LoginTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    // required dynamic key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Theme(
        data: ThemeData.light(),
        child: TextFormField(
            validator: (value) {
              // check that the string is valid and contains no forbidden characters
              final bool stringValid = RegExp(r"^[a-zA-Z._]+$").hasMatch(value.toString());
              if (value == null || value.isEmpty){
                return 'Please enter some text';
              } else if (!stringValid){
                return 'Invalid string';
              }
              return null;
            },
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              fillColor: const Color.fromARGB(250, 240, 240, 240),
              filled: true,
              hintText: hintText,
              hintStyle: AppTheme().hiddenTextStyleMedium,
            )),
      ),
    );
  }
}
