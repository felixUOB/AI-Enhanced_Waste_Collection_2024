import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperLinkText extends StatelessWidget {
  final String string1;
  final String hyperString;
  final String string2;
  final VoidCallback? onTap; // Add an onTap callback for register


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
            style: hyperLinkTextStyleMedium,
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
