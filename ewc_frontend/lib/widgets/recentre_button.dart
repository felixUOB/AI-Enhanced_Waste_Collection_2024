import 'package:flutter/material.dart';

/// This file manages the recentre button widget.
///
/// Functions:
/// - `build()`: Builds the recentre button.

class RecentreButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool centred;

  const RecentreButton({
    super.key,
    required this.centred,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: (centred) ? Icon(Icons.my_location) : Icon(Icons.location_searching)
    );
  }}