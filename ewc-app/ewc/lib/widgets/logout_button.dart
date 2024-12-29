import 'package:flutter/material.dart';

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
    Color? defaultColor = Theme.of(context).iconTheme.color;
    final Color hoverColor = Theme.of(context).colorScheme.primary;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 90),
      child: MouseRegion(
        onEnter: (event) {
          print("HOVERING");
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          print("NOT HOVERING");
          setState(() {
            isHovered = false;
          });
        },
        child: SizedBox(
          height: 50,
          width: 50,
          child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style,
            onPressed: widget.onPressed,
            child: Icon(
              widget.iconData,
              color: isHovered ? hoverColor : defaultColor,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
