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
        Icon(Icons.navigation):
        Icon(Icons.near_me_outlined)
    );
  }
}