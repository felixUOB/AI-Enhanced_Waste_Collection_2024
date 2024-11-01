import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperLinkText extends StatelessWidget {
  final String string1;
  final String hyperString;
  final String string2;
  final Uri link;


  HyperLinkText({
    super.key,
    required this.string1,
    required this.hyperString,
    required this.string2,
    required this.link,
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
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        ),
                      text: " $hyperString",
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        if(await canLaunchUrl(link)){
                          await launchUrl(
                            link, 
                          );
                        } else {
                          throw "Cannot load URL";
                        }
                      }
                    ),
                    TextSpan(
                      style: Theme.of(context).textTheme.bodySmall,
                      text: " $string2"
                    ),
                  ]
                )
    );
  }
}
