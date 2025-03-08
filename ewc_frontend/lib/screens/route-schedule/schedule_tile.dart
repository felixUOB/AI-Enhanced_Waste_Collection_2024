import 'package:ewc/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class ScheduleTile extends StatelessWidget {
  final String name;
  final int minutes;

  const ScheduleTile({
    super.key,
    required this.name,
    required this.minutes
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(children: [

        // ------------Stop name text------------
        Expanded(
          child: Text(name,
            textAlign: TextAlign.left, // display the stop name
            style: AppTheme().constWhiteTextLarge)
        ),

        // ------------Minutes text------------
        Expanded(
          child: (minutes != 0) ?
          Text(
            "$minutes mins", // display the stop time
            textAlign: TextAlign.right,
            style: AppTheme().constWhiteTextLarge,
          ) : Text("",
            textAlign: TextAlign.right,
            style: AppTheme().constWhiteTextLarge,
          )
        )
      ]),
    );
  }
}