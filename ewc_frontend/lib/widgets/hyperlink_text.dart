import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// This file manages the hyperlink text widget.
///
/// Functions:
/// - `build()`: Builds the hyperlink text.

class HyperLinkText extends StatelessWidget {
  final String string1;
  final String hyperString;
  final String string2;
  final VoidCallback? onTap; // Add an onTap callback for register


  // ignore: prefer_const_constructors_in_immutables
  HyperLinkText({
    super.key,
    required this.string1,
    required this.hyperString,
    required this.string2,
    this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            text: string1
          ),
          TextSpan(
            style: AppTheme().hyperLinkTextStyleMedium,
            text: " $hyperString",
            recognizer: TapGestureRecognizer()
              ..onTap = onTap,
          ),
          TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            text: " $string2"
          ),
        ]
      )
    );
  }
}
