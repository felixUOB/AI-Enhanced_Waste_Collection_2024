import 'package:flutter/material.dart';

class ScheduleStopList extends StatelessWidget {

  final bool inPast;
  // ignore: prefer_typing_uninitialized_variables
  final child;

  const ScheduleStopList({
      super.key,
      required this.inPast,
      required this.child,
    });

  // creates the box that will display the information about each of the stops
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: inPast ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.secondary, //different colour depending on if it has already happened or not
        borderRadius: BorderRadius.circular(8),
        ),
      child: child,
    );
  }
}