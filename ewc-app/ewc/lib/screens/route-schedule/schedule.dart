import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/widgets/timeline_tile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ewc/widgets/theme_switch.dart';

class Schedule extends StatelessWidget {
  // Hardcoded 'stop name' and 'minutes until stop reached' data
  // until map api is implemented
  final List<RouteStop> routes = [
    RouteStop(label: "stop 1", time: DateTime(2024, 11, 14, 15, 30)),
    RouteStop(label: "stop 2", time: DateTime(2024, 11, 14, 16, 00)),
    RouteStop(label: "stop 3", time: DateTime(2024, 11, 14, 16, 13)),
    RouteStop(label: "stop 4", time: DateTime(2024, 11, 14, 16, 30)),
  ];

  Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// ------------Top app bar------------

      appBar: AppBar(
        //toolbarHeight: 75,
        title: Text('Schedule',
            style: Theme.of(context).textTheme.titleLarge),
            //style: TextStyle(fontFamily: 'Questrial', fontSize: 32))
        // dark vs light mode toggle
        actions: [
          SafeArea(
          child: Container(
              // ignore: prefer_const_literals_to_create_immutables
              margin: EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  Padding(
                  padding: const EdgeInsets.all(3),
                  child:
                    // ignore: prefer_const_constructors
                    Align(
                      alignment: Alignment.topRight, 
                      // ignore: prefer_const_constructors
                      child: ThemeSwitch(),
                    )
                  )
                ],
              )
          ))// ignore: prefer_const_constructor 
          ],
      ),
// ------------List of stops------------
      // makes a scrollable list
      body: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: ListView.builder(
            itemCount: routes.length,
            itemBuilder: (BuildContext context, int index){
              return CustomTimelineTile(
                inPast: checkTimeLabel(routes[index]), // checks if its in the past or in the future
                isFirst: (index == 0) ? true : false, // if it is the first index set the property to true
                isLast: (index == routes.length-1) ? true : false, // checks if its the last in the list
                eventCard: Row(
                  children: [
// ------------Stop name text------------
                  Expanded(
                    child: Text(
                      routes[index].label, textAlign: TextAlign.left, // display the stop name
                      style: AppTheme().constWhiteTextLarge)
                  ),
// ------------Minutes text------------
                  Expanded(
                    child: Text(
                      DateFormat('kk:mm').format(routes[index].time), // display the stop time
                      textAlign: TextAlign.right,
                      style: AppTheme().constWhiteTextLarge,
                      )
                  )
                ]
                ),
              );
            }
          )
        )
      )
    );
  }
}

// data structure for the stop
class RouteStop {
  final String label;
  final DateTime time;
  RouteStop({required this.label, required this.time});
}

// checkTimeLabel returns true if the time given to it is before the current time
bool checkTimeLabel(RouteStop timeLable){
  DateTime now = DateTime.now();
  if (timeLable.time.isBefore(now)){
    return true;
  }else{
    return false;
  }
}