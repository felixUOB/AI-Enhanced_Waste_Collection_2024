import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text1;
  final VoidCallback? onPressed; // function to be enacted when the button is pressed

  const LoginButton({
    super.key,
    required this.text1,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Center(
          child: Text(
            " $text1",
            style: constWhiteTextMedium,
            ),
        ),
      )
      )
    );
  }
}
