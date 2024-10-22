
import 'package:ewc/screens/metrics/graphs/bar%20graph/bar_graph.dart';
import 'package:ewc/screens/metrics/widgets/square.dart';
import 'package:flutter/material.dart';

class MetricsPage extends StatefulWidget{
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage>{
  @override
  Widget build(BuildContext context){
    final List metrics = ['carbon footprint', 'fuel consumption'];


    List<double> weeklycarbon = [
      2.4,
      2.4,
      3.2,
      4.5,
      6.7,
      6.7,
      5.4
    ];

    return Scaffold(
      body: Column(
        children: [
          //MyBarGraph(),
          Text("Hello"),



          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink,)
              ),
            ],
          
          ),
          Expanded(
            child: ListView.builder(
              itemCount: metrics.length,
              itemBuilder: (context, index){
                return MySquare(child: metrics[index]);
              },
            ),
          ),
        ],
      ),
    );

  }
}