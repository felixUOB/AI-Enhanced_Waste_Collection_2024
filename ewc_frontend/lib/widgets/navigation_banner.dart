import 'package:flutter/material.dart';

/// Navigation banner displayed at the top of the screen with a fixed size and dynamic text.
class NavigationBanner extends StatelessWidget {
  final bool visible;
  final String instruction;
  final IconData icon;
  final Duration animationDuration;

  const NavigationBanner({
    super.key,
    required this.visible,
    required this.instruction,
    required this.icon,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset(0, 0) : Offset(0, -1),
      duration: animationDuration,
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: animationDuration,
        curve: Curves.easeInOut,
        child: SafeArea(
          child: Container(
            height: 80,
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    instruction,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.visible,
                  ),
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
        ),
      ),
    );
  }
}
