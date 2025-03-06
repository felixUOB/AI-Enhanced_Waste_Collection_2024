import 'package:flutter/material.dart';

/// Navigation banner displayed at the top of the screen with a fixed size and dynamic text.
class NavigationBanner extends StatelessWidget {

  final String instruction;
  final IconData icon;

  const NavigationBanner({
    super.key,
    required this.instruction,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 80,
        color: Colors.blueAccent,
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(instruction,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible,),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(icon, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
