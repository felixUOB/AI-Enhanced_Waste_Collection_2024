import 'package:flutter/material.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Center(
              heightFactor: 1.5,
              child: Text('Schedule', style: TextStyle(fontSize: 32, fontFamily: 'Questrial')))
            ),
        body: ListView.builder(
            itemCount: routes.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.cyan, borderRadius: BorderRadius.circular(12)
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: DefaultTextStyle.merge(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${routes[index][0]}', textAlign: TextAlign.left),
                      ),
                      Expanded(
                        child: Text('${routes[index][1]} mins', textAlign: TextAlign.right)
                      )
                    ]
                  ),
                  style: const TextStyle(fontSize: 24, fontFamily: 'Questrial'),
                )
              );
            }
        ),
      ),
    );
  }
}