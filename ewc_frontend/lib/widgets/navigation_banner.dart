import 'package:flutter/material.dart';

/// This file manages the navigation banner widget.
///
/// Functions:
/// - `build()`: Builds the navigation banner widget.
/// - `getInstructionIcon()`: Returns the appropriate icon based on the given instruction text.

class NavigationBanner extends StatelessWidget {
  // Determines if the banner should be visible.
  final bool visible;
  // The text instruction to be displayed in the banner.
  final String instruction;
  final Duration animationDuration;

  const NavigationBanner({
    super.key,
    required this.visible,
    required this.instruction,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  // Returns the appropriate icon based on the given instruction text, based on the presense of certain key words.
  IconData getInstructionIcon(String instruction) {
    instruction = instruction.toLowerCase();
    if (instruction.contains("left")) {
      return Icons.turn_left;
    } else if (instruction.contains("right")) {
      return Icons.turn_right;
    } else if (instruction.contains("straight")) {
      return Icons.straight;
    } else if (instruction.contains("u-turn")) {
      return Icons.u_turn_left;
    } else {
      return Icons.navigation;
    }
  }


  @override
  Widget build(BuildContext context) {
    final icon = getInstructionIcon(instruction);
    return AnimatedSlide(
      // Slide the banner in or out depending on the visibility flag.
      offset: visible ? Offset(0, 0) : Offset(0, -1),
      duration: animationDuration,
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        // Adjust the opacity based on visibility.
        opacity: visible ? 1.0 : 0.0,
        duration: animationDuration,
        curve: Curves.easeInOut,
        child: SafeArea(
          // Ensure that the banner does not overlap system UI elements.
          child: Container(
            height: 80,
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            // Styling for the banner container.
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            // Layout the instruction text and computed icon side by side.
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
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
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
