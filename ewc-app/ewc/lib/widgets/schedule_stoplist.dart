import 'package:flutter/material.dart';

class ScheduleStopList extends StatelessWidget {
  // List content
  final List<List<Object>> content;

  const ScheduleStopList(
    {
      super.key,
      required this.content
    }
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: content.length,

      // itemBuilder to describe how each list item is built
      itemBuilder: (BuildContext context, int index) {
        return Container(

          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(left:12, right:12, bottom: 12),

          decoration: BoxDecoration(
            color: Colors.cyan, borderRadius: BorderRadius.circular(12)
          ),

          child: DefaultTextStyle.merge(
            child: Row(
              children: [

// ------------Stop name text------------

                Expanded(
                  child: Text(
                    '${content[index][0]}', textAlign: TextAlign.left)
                ),

// ------------Minutes text------------

                Expanded(
                  child: Text(
                    '${content[index][1]} mins', textAlign: TextAlign.right)
                )
              ]
            ),
          style: const TextStyle(fontSize: 24, fontFamily: 'Questrial'),)
        );
      }
    );
  }
}