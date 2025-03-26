import 'package:flutter/material.dart';

/// This file manages the schedule stop list widget.
///
/// Functions:
/// - `build()`: Builds the schedule stop list.

class ScheduleStopList extends StatelessWidget {

  final bool inPast;
  final Widget child;

  const ScheduleStopList({
      super.key,
      required this.inPast,
      required this.child,
    });

  // creates the box that will display the information about each of the stops
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: inPast ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.secondary, //different colour depending on if it has already happened or not
        borderRadius: BorderRadius.circular(8),
        ),
      child: child,
    );
  }
}