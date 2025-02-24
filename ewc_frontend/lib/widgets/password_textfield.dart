import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class PasswordTextfield extends StatefulWidget {
  final dynamic controller;
  final String hintText;
  
  const PasswordTextfield({
    super.key, 
    required this.controller,
    required this.hintText,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfield();
}

class _PasswordTextfield extends State<PasswordTextfield> {
  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Theme(
        data: ThemeData.light(),
        child: TextField(
          controller: widget.controller,
          obscureText: obscured,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            fillColor: const Color.fromARGB(250, 240, 240, 240),
            filled: true,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscured = !obscured;
                });
              },
              icon: (obscured) ? Icon(Icons.visibility_off, color: Colors.grey[400])
                               : Icon(Icons.visibility, color: Colors.grey[400])
            ),
            hintText: widget.hintText,
            hintStyle: AppTheme().hiddenTextStyleMedium,
          )
        ),
      ),
    );
  }
}
