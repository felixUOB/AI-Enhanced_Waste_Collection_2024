import 'package:flutter/material.dart';

/// This file manages the orientate button widget.
///
/// Functions:
/// - `onPressed`: Callback function when the button is pressed.
/// - `north`: Indicates whether the button indicates north direction.

class OrientateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool north;

  const OrientateButton({
    super.key,
    required this.north,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "orientate button",
      onPressed: onPressed,
      child: (north) ?
        Icon(Icons.navigation):
        Icon(Icons.near_me_outlined)
    );
  }
}