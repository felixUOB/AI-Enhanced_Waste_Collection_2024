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
        onPressed: onPressed,
        child: (north) ?
          Transform.rotate(angle: -20, child: Icon(Icons.explore),):
          Icon(Icons.explore)
    );
  }}