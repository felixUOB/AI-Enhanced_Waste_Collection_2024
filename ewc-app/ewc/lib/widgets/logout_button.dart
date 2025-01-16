import 'package:flutter/material.dart';

// LogoutButton is a button widget that triggers a logout action
// ignore: must_be_immutable
class LogoutButton extends StatefulWidget {
  IconData iconData;
  final VoidCallback onPressed;

  LogoutButton({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  @override
  State<LogoutButton> createState() => LogoutButtonState();
}

class LogoutButtonState extends State<LogoutButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 90),
      child: SizedBox(
        height: 50,
        width: 50,
        child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: widget.onPressed,
          child: Icon(
            widget.iconData,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
      ),
    );
  }
}
