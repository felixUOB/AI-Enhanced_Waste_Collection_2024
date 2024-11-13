import 'package:flutter/material.dart';
import '../../widgets/schedule_stoplist.dart';



class Schedule extends StatelessWidget {
  // Hardcoded 'stop name' and 'minutes until stop reached' data
  // until map api is implemented
  final routes = const [
    ["stop 1",5],
    ["stop 2",8],
    ["stop 3",11],
    ["stop 4",15],
  ];

  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

// ------------Top app bar------------

      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        toolbarHeight: 75,
        title: const Text('Schedule',
            style: TextStyle(fontFamily: 'Questrial', fontSize: 32))
      ),

// ------------List of stops------------
      body: SafeArea(
          child: ScheduleStopList(content: routes)),
    );
  }
}