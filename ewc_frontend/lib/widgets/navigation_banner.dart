import 'package:flutter/material.dart';

/// Navigation banner displayed at the top of the screen with a fixed size.
class NavigationBanner extends StatelessWidget {
  const NavigationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60, // Fixed height
        color: Colors.blueAccent, // Background color
        alignment: Alignment.center,
        child: Text(
          "Navigation Banner",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
