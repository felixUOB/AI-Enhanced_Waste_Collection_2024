import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text1;

  LoginButton({
    super.key,
    required this.text1
    });



  @override
  Widget build(BuildContext context) {
    return Padding(
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
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontFamily: "Questrial",
          ),
          ),
      ),
    )
    );
  }
}
