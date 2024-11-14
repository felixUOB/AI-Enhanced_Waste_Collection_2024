import 'package:flutter/material.dart';

class ScheduleStopList extends StatelessWidget {
  // List content
  //final List<List<Object>> content;
  final bool inPast;
  final child;

  const ScheduleStopList({
      super.key,
      required this.inPast,
      required this.child,
    });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: inPast ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
        ),
      child: child,
    );
  }
}