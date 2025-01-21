import 'package:flutter/material.dart';

class RecentreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RecentreButton({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.my_location)
    );
  }}