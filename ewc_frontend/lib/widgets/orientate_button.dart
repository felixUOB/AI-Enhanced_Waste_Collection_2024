import 'package:flutter/material.dart';

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
      // Not sure which icons are intuitive here
        Icon(Icons.arrow_circle_up):
        Icon(Icons.change_circle_outlined)
    );
  }
}