import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text1;
  final VoidCallback onPressed; // Added onPressed parameter

  const LoginButton({
    super.key,
    required this.text1,
    required this.onPressed, // Added onPressed to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: ElevatedButton(
        key: Key("loginButton"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onPressed, // Set onPressed action
        child: Text(
          " $text1",
          style: AppTheme().constWhiteTextMedium,
        ),
      ),
    );
  }
}
