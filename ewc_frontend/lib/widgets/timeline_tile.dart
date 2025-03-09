import 'package:ewc/widgets/schedule_stoplist.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';

class CustomTimelineTile extends StatelessWidget{
  final bool isFirst;
  final bool isLast;
  final bool inPast;
  final Widget eventCard;

  const CustomTimelineTile({
    super.key,
    required this.inPast,
    required this.isFirst,
    required this.isLast,
    required this.eventCard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        // decorate the line
        beforeLineStyle: LineStyle(
          color: inPast ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.secondary
          ),
        indicatorStyle: IndicatorStyle(
          width: 40, 
          color: inPast ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.secondary,
          iconStyle: IconStyle(
            iconData: Icons.done,
            color: inPast ? Colors.white: Theme.of(context).colorScheme.secondary,),
        ),
        endChild: ScheduleStopList(
          inPast: inPast,
          child: eventCard,
        ),
      ),
    );
  }
} 